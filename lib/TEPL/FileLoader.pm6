use v6.c;

use Method::Also;
use NativeCall;

use TEPL::Raw::Types;
use TEPL::Raw::FileLoader;

use GLib::Value;
use TEPL::Buffer;
use TEPL::File;

use GLib::Roles::Object;
use GIO::Roles::GFile;

class TEPL::FileLoader {
  also does GLib::Roles::Object;

  has TeplFileLoader $!fl;

  method BUILD (:$loader) {
    self.setObject($!fl = $loader);
  }

  method TEPL::Raw::Types::TeplFileLoader
    is also<
      TeplFileLoader
      FileLoader
    >
  { $!fl }

  multi method new (TeplFileLoadfer $loader) {
    $loader ?? self.bless( :$loader ) !! Nil;
  }
  multi method new (TeplBuffer $buffer, TeplFile $file) {
    my $loader = tepl_file_loader_new($buffer, $file);

    $loader ?? self.bless( :$loader ) !! Nil;
  }

  # Type: gint64
  method chunk-size is rw  {
    my GLib::Value $gv .= new( G_TYPE_INT64 );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('chunk-size', $gv)
        );
        $gv.int64;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int64 = $val;
        self.prop_set('chunk-size', $gv);
      }
    );
  }

  # Type: gint64
  method max-size is rw  {
    my GLib::Value $gv .= new( G_TYPE_INT64 );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('max-size', $gv)
        );
        $gv.int64;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int64 = $val;
        self.prop_set('max-size', $gv);
      }
    );
  }

  method error_quark (TEPL::FileLoader:U: ) is also<error-quark> {
    tepl_file_loader_error_quark();
  }

  method get_buffer (:$raw = False)
    is also<
      get-buffer
      buffer
    >
  {
    my $b = tepl_file_loader_get_buffer($!fl);

    $b ??
      ( $raw ?? $b !! TEPL::Buffer.new($b) )
      !!
      TeplBuffer;
  }

  method get_encoding (:$raw = False)
    is also<
      get-encoding
      encoding
    >
  {
    my $e = tepl_file_loader_get_encoding($!fl);

    $e ??
      ( $raw ?? $e !! TEPL::Encoding.new($e) )
      !!
      TeplEncoding;
  }

  method get_file (:$raw = False)
    is also<
      get-file
      file
    >
  {
    my $tf = tepl_file_loader_get_file($!fl);

    $tf ??
      ( $raw ?? $tf !! TEPL::File.new($tf) )
      !!
      TeplFile;
  }

  method get_location (:$raw = False)
    is also<
      get-location
      location
    >
  {
    my $gf = tepl_file_loader_get_location($!fl);

    $gf ??
      ( $raw ?? $gf !! GIO::Roles::GFile.new-file-obj($gf) )
      !!
      GFile;
  }

  method get_newline_type
    is also<
      get-newline-type
      newline_type
      newline-type
    >
  {
    TeplNewlineTypeEnum( tepl_file_loader_get_newline_type($!fl) );
  }

  proto method load_async (|)
    is also<load-async>
  { * }

  multi method load_async (
    Int() $io_priority,
    &callback,
    &progress_callback                       = Callable,
    gpointer $user_data                      = Pointer,
    gpointer $progress_callback_data         = Pointer,
    GCancellable() $cancellable              = GCancellable,
    GDestroyNotify $progress_callback_notify = Pointer
  ) {
    samewith(
      $io_priority,
      $cancellable,
      &progress_callback,
      $progress_callback_data,
      $progress_callback_notify,
      &callback,
      $user_data
    );
  }
  multi method load_async (
    Int() $io_priority,
    GCancellable() $cancellable,
    &progress_callback,
    gpointer $progress_callback_data,
    GDestroyNotify $progress_callback_notify,
    &callback,
    gpointer $user_data
  ) {
    my guint $io = $io_priority;
    
    tepl_file_loader_load_async(
      $!fl,
      $io,
      $cancellable,
      &progress_callback,
      $progress_callback_data,
      $progress_callback_notify,
      &callback,
      $user_data
    );
  }

  method load_finish (
    GAsyncResult() $result,
    CArray[Pointer[GError]] $error = gerror()
  )
    is also<load-finish>
  {
    clear_error;
    my $rc = so tepl_file_loader_load_finish($!fl, $result, $error);
    set_error($error);
    $rc;
  }


}
