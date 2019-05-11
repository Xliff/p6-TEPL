use v6.vc;

use Method::Also;

use GTK::Compat::Types;
use TEPL::Raw::Types;

use GTK::Raw::Utils;

use TEPL::Raw::FileSaver;

use GTK::Compat::Roles::GFile;
use GTK::Compat::Roles::Object;

class TEPL::FileSaver {
  also does GTK::Compat::Roles::Object;

  has TeplFileSaver $!fs;

  submethod BUILD (:$saver) {
    self!setObject($!fs = $saver);
  }

  method TEPL::Raw::Types::TeplFileSaver
    is also<
      TeplFileSaver
      FileSaver
    >
  { $!fs }

  method new (TeplFile() $file) {
    self.bless( saver => tepl_file_saver_new($!fs, $file) );
  }

  method new_with_target (TeplFile() $file, GFile() $target_location)
    is also<new-with-target>
  {
    self.bless(
      saver => tepl_file_saver_new_with_target($!fs, $file, $target_location)
    );
  }

  method compression-type is also<compression_type> is rw {
    Proxy.new:
      FETCH => -> $             { self.get_compression_type },
      STORE => -> $, Int() \val { self.set_compression_type(val) };
  }

  method encoding is rw {
    Proxy.new:
      FETCH => -> $                    { self.get_encoding },
      STORE => -> $, TeplEncoding() $e { self.set_encoding($e) };
  }

  method flags is rw {
    Proxy.new:
      FETCH => -> $           { self.get_flags },
      STORE => -> $, Int() $f { self.set_flags($f) };
  }

  method newline-type is also<newline_type> is rw {
    Proxy.new:
      FETCH => -> $            { self.get_newline_type },
      STORE => -> $, Int() $nt { self.set_newline_type($nt) };
  }

  method error_quark is also<error-quark> {
    tepl_file_saver_error_quark($!fs);
  }

  method get_buffer
    is also<
      get-buffer
      buffer
    >
  {
    tepl_file_saver_get_buffer($!fs);
  }

  method get_compression_type is also<get-compression-type>
  {
    tepl_file_saver_get_compression_type($!fs);
  }

  method get_encoding is also<get-encoding>
  {
    tepl_file_saver_get_encoding($!fs);
  }

  method get_file
    is also<
      get-file
      file
    >
  {
    tepl_file_saver_get_file($!fs);
  }

  method get_flags is also<get-flags> {
    tepl_file_saver_get_flags($!fs);
  }

  method get_location
    is also<
      get-location
      location
    >
  {
    GTK::Compat::Roles::GFile.new( tepl_file_saver_get_location($!fs) );
  }

  method get_newline_type is also<get-newline-type> {
    TeplNewlineType( tepl_file_saver_get_newline_type($!fs) );
  }

  method get_type is also<get-type> {
    tepl_file_saver_get_type();
  }

  proto method save_async (|)
    is also<save-async>
  { * }

  multi method save_async (
    Int() $io_priority,
    &callback,
    &progress_callback                       = -> { },
    GCancellable $cancellable                = Pointer,
    GDestroyNotify $progress_callback_notify = Pointer,
    gpointer $progress_callback_data         = Pointer,
    gpointer $user_data                      = Pointer
  ) {
    samewith (
      $io_priority,
      $cancellable,
      &progress_callback,
      $progress_callback_data,
      $progress_callback_notify,
      &callback,
      $user_data
    );
  }
  multi method save_async (
    Int()                 $io_priority,
    GCancellable          $cancellable,
                          &progress_callback,
    gpointer              $progress_callback_data,
    GDestroyNotify        $progress_callback_notify,
                          &callback,
    gpointer              $user_data
  )
    is also<save-async>
  {
    my gint $io = resolve-int($io_priority);
    tepl_file_saver_save_async(
      $!fs,
      $io,
      $cancellable,
      &progress_callback,
      $progress_callback_data,
      $progress_callback_notify,
      &callback,
      $user_data
    );
  }

  method save_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error = gerror()
  )
    is also<save-finish>
  {
    clear_error;
    my $rc = tepl_file_saver_save_finish($!fs, $result, $error);
    set_error($error);
    $rc;
  }

  method set_compression_type (Int() $compression_type)
    is also<set-compression-type>
  {
    my guint $ct = resolve-uint($compression_type);
    tepl_file_saver_set_compression_type($!fs, $ct);
  }

  method set_encoding (TeplEncoding() $encoding) is also<set-encoding> {
    tepl_file_saver_set_encoding($!fs, $encoding);
  }

  method set_flags (Int() $flags) is also<set-flags> {
    my guint $f = resolve-uint($flags);
    tepl_file_saver_set_flags($!fs, $f);
  }

  method set_newline_type (Int() $newline_type)
    is also<set-newline-type>
  {
    my guint $nt = resolve-uint($newline_type);
    tepl_file_saver_set_newline_type($!fs, $nt);
  }

}
