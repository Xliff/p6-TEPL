use v6.c;

use Method::Also;
use NativeCall;

use TEPL::Raw::Types;
use TEPL::Raw::FileSaver;

use GLib::Roles::Object;
use GIO::Roles::GFile;

class TEPL::FileSaver {
  also does GLib::Roles::Object;

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

  multi method new (TeplFileSaver $saver) {
    $saver ?? self.bless(:$saver) !! Nil;
  }
  multi method new (TeplBuffer() $buffer, TeplFile() $file) {
    my $saver = tepl_file_saver_new($buffer, $file);

    $saver ?? self.bless(:$saver) !! Nil;
  }

  method new_with_target (
    TeplBuffer() $buffer,
    TeplFile() $file,
    GFile() $target_location
  )
    is also<new-with-target>
  {
    my $saver = tepl_file_saver_new_with_target(
      $buffer,
      $file,
      $target_location
    );

    $saver ?? self.bless(:$saver) !! Nil;
  }

  method compression-type is also<compression_type> is rw {
    Proxy.new:
      FETCH => sub ($)          { self.get_compression_type      },
      STORE => -> $, Int() \val { self.set_compression_type(val) };
  }

  method encoding (:$raw = False) is rw {
    Proxy.new:
      FETCH => sub ($)                 { self.get_encoding(:$raw) },
      STORE => -> $, TeplEncoding() $e { self.set_encoding($e) }   ;
  }

  method flags is rw {
    Proxy.new:
      FETCH => sub ($)        { self.get_flags },
      STORE => -> $, Int() $f { self.set_flags($f) };
  }

  method newline-type is also<newline_type> is rw {
    Proxy.new:
      FETCH => sub ($)         { self.get_newline_type },
      STORE => -> $, Int() $nt { self.set_newline_type($nt) };
  }

  method error_quark (TEPL::FileSaver:U: ) is also<error-quark> {
    tepl_file_saver_error_quark();
  }

  method get_buffer (:$raw = False)
    is also<
      get-buffer
      buffer
    >
  {
    my $b = tepl_file_saver_get_buffer($!fs);

    $b ??
      ( $raw ?? $b !! TEPL::Buffer.new($b) )
      !!
      TeplBuffer;
  }

  method get_compression_type is also<get-compression-type>
  {
    TeplCompressionTypeEnum( tepl_file_saver_get_compression_type($!fs) );
  }

  method get_encoding (:$raw = False) is also<get-encoding>
  {
    my $e = tepl_file_saver_get_encoding($!fs);

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
    my $tf = tepl_file_saver_get_file($!fs);

    $tf ??
      ( $raw ?? $tf !! TEPL::File.new($tf) )
      !!
      TeplFile;
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
    GIO::Roles::GFile.new-file-obj( tepl_file_saver_get_location($!fs) );
  }

  method get_newline_type is also<get-newline-type> {
    TeplNewlineTypeEnum( tepl_file_saver_get_newline_type($!fs) );
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &tepl_file_saver_get_type, $n, $t );
  }

  proto method save_async (|)
    is also<save-async>
  { * }

  multi method save_async (|c) {
    if tepl-version < 5 {
      samewith( |c, :pre5 );
    } else {
      samewith( |c, :post5 );
    }
  }

  constant DN = %DEFAULT-CALLBACKS<GDestroyNotify>;

  multi method save_async (
    Int()           $io_priority,
                    &callback,
                    &progress_callback                    = Callable,
    GCancellable()  $cancellable                          = GCancellable,
                    &progress_callback_notify             = DN,
    gpointer        $progress_callback_data               = Pointer,
    gpointer        $user_data                            = Pointer,
                   :$pre5                     is required
  ) {
    samewith (
      $io_priority,
      $cancellable,
      &progress_callback,
      $progress_callback_data,
      &progress_callback_notify,
      &callback,
      $user_data
    );
  }
  multi method save_async (
    Int()           $io_priority,
    GCancellable()  $cancellable,
                    &progress_callback,
    gpointer        $progress_callback_data,
                    &progress_callback_notify,
                    &callback,
    gpointer        $user_data,
                   :$pre5                     is required
  ) {
    my gint $io = $io_priority;

    tepl_file_saver_save_async(
      $!fs,
      $io,
      $cancellable,
      &progress_callback,
      $progress_callback_data,
      &progress_callback_notify,
      &callback,
      $user_data
    );
  }

  method save_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error = gerror()
  ) {
    clear_error;
    my $rc = so tepl_file_saver_save_finish($!fs, $result, $error);
    set_error($error);
    $rc;
  }

  method set_compression_type (Int() $compression_type)
    is also<set-compression-type>
  {
    my guint $ct = $compression_type;

    tepl_file_saver_set_compression_type($!fs, $ct);
  }

  method set_encoding (TeplEncoding() $encoding) is also<set-encoding> {
    tepl_file_saver_set_encoding($!fs, $encoding);
  }

  method set_flags (Int() $flags) is also<set-flags> {
    my guint $f = $flags;

    tepl_file_saver_set_flags($!fs, $f);
  }

  method set_newline_type (Int() $newline_type)
    is also<set-newline-type>
  {
    my guint $nt = $newline_type;

    tepl_file_saver_set_newline_type($!fs, $nt);
  }

}
