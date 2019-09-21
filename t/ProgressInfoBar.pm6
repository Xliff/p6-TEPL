use v6.c;

use Method::Also;

use URI;

use GTK::Compat::Types;
use GTK::Raw::Types;
use SourceViewGTK::Raw::Types;

use GTK::Raw::Utils;

use GLib::Error;
use GLib::Unicode;

use GTK::Grid;
use GTK::Label;
use GTK::ProgressBar;

use SourceViewGTK::Encoding;
use SourceViewGTK::FileLoader;
use TEPL::InfoBar;

use GLib::Raw::Quarks;
use GIO::Raw::Quarks;
use SourceViewGTK::Raw::Quarks;

class TEPL::ProgressInfoBar is TEPL::InfoBar is export {
  has $!l          handles <text>;
  has $!pb         handles <pulse fraction>;
  has $!vgrid;
  has $!cancel;

  method bless(*%attrinit) {
    my $o = self.CREATE.BUILDALL(Empty, %attrinit);
    $o.setType($o.^name);
    $o;
  }

  submethod BUILD (:$info-bar, :$!cancel) {
    # We are basically consuming the info-bar, so we must up its ref count.
    self.setTeplInfoBar($info-bar.ref.TeplInfoBar);

    $!vgrid = GTK::Grid.new-vgrid(6);
    $!l = self.create_label;
    $!pb = GTK::ProgressBar.new;
    $!pb.hexpand = True;
    $!vgrid.add($_) for $!l, $!pb;
    self.content_area.add($!vgrid);
    self.set-has-cancel-button($!cancel);
    $!vgrid.show_all
  }

  multi method new (Str() $markup, Int() $has_cancel_button) {
    my $o = self.bless(
      info-bar => TEPL::InfoBar.new,
      cancel => $has_cancel_button
    );
    $o.markup = $markup if $markup;
    $o;
  }

  method markup is rw {
    # Note that there is no GTK::Label.get_markup, so we have to use .label
    Proxy.new:
      FETCH => -> $,                { $!l.label },
      STORE => -> $, Str() $markup  { $!l.set-markup($markup) };
  }

  method set-has-cancel-button (Int() $hcb) is also<set_has_cancel_button> {
    $!cancel = resolve-bool($hcb);

    return unless $!cancel;
    self.add-button('_Cancel', GTK_RESPONSE_CANCEL);
  }

}

class TEPL::ErrorInfoBar is TEPL::InfoBar is export {

  method bless(*%attrinit) {
    my $o = self.CREATE.BUILDALL(Empty, %attrinit);
    $o.setType($o.^name);
    $o;
  }

  submethod BUILD (:$info-bar) {
    self.setTeplInfoBar($info-bar.ref.TeplInfoBar);
  }

  method new {
    my $o = self.bless( info-bar => TEPL::InfoBar.new );
    $o;
  }

  method is_recoverable_error (GError() $e) is also<is-recoverable-error> {
    return False unless $e.domain == $G_IO_ERROR;
    return False unless $e.code == (
      G_IO_ERROR_PERMISSION_DENIED,
      G_IO_ERROR_NOT_FOUND,
      G_IO_ERROR_HOST_NOT_FOUND,
      G_IO_ERROR_TIMED_OUT,
      G_IO_ERROR_NOT_MOUNTABLE_FILE,
      G_IO_ERROR_NOT_MOUNTED,
      G_IO_ERROR_BUSY
    ).any;
    True;
  }

  method parse_error ($e, GFile() $l, Str() $uri, $p is rw, $s is rw)
    is also<parse-error>
  {
    die '$e is not a GLib::Error object!' unless $e ~~ GLib::Error;

    given $e {
      when (
        .matches($G_IO_ERROR, G_IO_ERROR_NOT_FOUND),
        .matches($G_IO_ERROR, G_IO_ERROR_NOT_DIRECTORY)
      ).any {
        $p = "Could not find the file “{ $uri }”.";
        $s = 'Please check that you typed the location correctly and try again.';
      }

      when (
        .matches($G_IO_ERROR, G_IO_ERROR_NOT_SUPPORTED),
        $l.defined
      ).all {
        my $scheme = $l.uri-scheme;

        $s = "Unable to handle “{$scheme}:” locations.";
      }

      when .matches($G_IO_ERROR, G_IO_ERROR_IS_DIRECTORY) {
        $p = "“{$uri}” is a directory.";
        $s = 'Please check that you typed the location correctly and try again.';
      }

      when .matches($G_IO_ERROR, G_IO_ERROR_HOST_NOT_FOUND) {
        my ($u, $h);

        $u = $l.uri if $l;
        $h = URI.new($u).host if $u;

        if $h {
          my $h8 = GLib::Unicode.utf8-make-valid($h);
          $s = qq:to/HOST/.chomp;
            Host “%s” could not be found. Please check that your proxy {''
            }settings are correct and try again.
            HOST
        } else {
          $s = qq:to/HOST/.chomp;
            Hostname was invalid. Please check that you typed the location {''
            }correctly and try again.
            HOST
        }
      }

      when .matches($G_IO_ERROR, G_IO_ERROR_NOT_REGULAR_FILE) {
        $s = "“{$uri}” is not a regular file.";
      }

      when .matches($G_IO_ERROR, G_IO_ERROR_TIMED_OUT) {
        $s = 'Connection timed out. Please try again.';
      }

      default {
        $s = "Unexpected error: { $e.message }";
      }
    }
  }

  method set_io_loading_error (Int() $recoverable)
    is also<set-io-loading-error>
  {
    my gboolean $r = so $recoverable;

    self.message-type = GTK_MESSAGE_ERROR;
    self.add-button('_Cancel', GTK_RESPONSE_CANCEL);
    self.add-button('_Retry', GTK_RESPONSE_OK) if $r;
  }

  method set_conversion_error (Int() $edit-anyways)
    is also<set-conversion-error>
  {
    my gboolean $e = so $edit-anyways;

    self.message-type = $e ?? GTK_MESSAGE_WARNING !! GTK_MESSAGE_ERROR;
    self.add_button('Edit any _way', GTK_RESPONSE_YES) if $e;
    self.add-button('_Cancel', GTK_RESPONSE_CANCEL);
  }

  method set_loading_error ($loader is copy, $error is copy)
    is also<set-loading-error>
  {
    $error = GLib::Error.new($error) if $error ~~ GError;

    die '$error must be a GLib::Error or GError object!'
      unless $error ~~ GLib::Error;

    return unless $error.domain == (
      $GTK_SOURCE_FILE_LOADER_ERROR,
      $G_IO_ERROR,
      $G_CONVERT_ERROR
    ).any;

    $loader = SourceViewGTK::FileLoader.new($loader) unless
      $loader ~~ SourceViewGTK::FileLoader;

    my ($location, $encoding) = ($loader.location, $loader.encoding);
    my $displayUri = $location.defined ??
      GTK::Compat::Roles::GFile.parse-name($location) !! 'stdin';
    my ($edit-anyways, $convert-error, $primary, $secondary) = False xx 2;

    given $error {
      when .matches($G_IO_ERROR, G_IO_ERROR_TOO_MANY_LINKS) {
        $secondary = qq:to/SEC/.chomp;
          The number of followed links is limited and the actual file could { ''
          }not be found within this limit.
          SEC
      }

      when .matches($G_IO_ERROR, G_IO_ERROR_PERMISSION_DENIED) {
        $secondary = qq:to/SEC/.chomp;
          You do not have the permissions necessary to open the file.
          SEC
      }

      when .matches($G_IO_ERROR, G_IO_ERROR_INVALID_DATA) {
        $convert-error = True;
        $secondary = qq:to/SEC/.chomp;
          Unable to detect the character encoding.
					Please check that you are not trying to open a binary file.
					Select a character encoding from the menu and try again.
          SEC
      }

      when (
        .matches($G_IO_ERROR, G_IO_ERROR_INVALID_DATA) && $encoding.defined.not,
        .matches(
          $GTK_SOURCE_FILE_LOADER_ERROR,
				  GTK_SOURCE_FILE_LOADER_ERROR_ENCODING_AUTO_DETECTION_FAILED
        )
      ).any {
        $convert-error = $edit-anyways = True;
        $secondary = qq:to/SEC/.chomp;
          The file you opened has some invalid characters. { ''
          }If you continue editing this file you could corrupt it.
  			  You can also choose another character encoding and try again.
          SEC
      }

      when .matches(
        $GTK_SOURCE_FILE_LOADER_ERROR,
				GTK_SOURCE_FILE_LOADER_ERROR_CONVERSION_FALLBACK
      ) {
        $convert-error = True;

        $primary = "Could not open the file “{ $displayUri
                    }” using the “{ $encoding // '-UNKNOWN-'
                    }” character encoding.";

        $secondary = qq:to/SEC/.chomp;
          Please check that you are not trying to open a binary file.
          Select a different character encoding from the menu and try again.
          SEC
      }

      default {
        self.parse_error($_, $location, $displayUri, $primary, $secondary);
      }
    }

    $convert-error ??
      self.set-conversion-error($edit-anyways)
      !!
      self.set-io-loading-error( self.is-recoverable-error($error) );

    $primary = "Could not open the file “{ $displayUri }”" unless $primary;
    self.add-secondary-message($secondary) if $secondary;
  }

}
