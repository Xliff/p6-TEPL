use v6.c;

use Method::Also;
use NativeCall;

use GTK::Compat::Types;
use TEPL::Raw::Types;

use GTK::Raw::Utils;

use TEPL::Raw::FileMetadata;

use GLib::Roles::Object;

class TEPL::FileMetadata {
  also does GLib::Roles::Object;

  has TeplFileMetadata $!tfm;

  submethod BUILD (:$metadata) {
    self!setObject($!tfm = $metadata);
  }

  method TEPL::Raw::Types::TeplFileMetadata
    is also<
      TeplFileMetadata
      FileMetadata
    >
  { $!tfm }

  multi method new (TeplFileMetadata $metadata) {
    self.bless(:$metadata);
  }
  multi method new (::('TEPL::File') $file) {
    samewith($file.File);
  }
  multi method new (TeplFile $file) {
    self.bless( metadata => tepl_file_metadata_new($file) );
  }

  method get (Str() $key) {
    tepl_file_metadata_get($!tfm, $key);
  }

  method get_file is also<get-file> {
    ::('TEPL::File').new(tepl_file_metadata_get_file($!tfm) );
  }

  method load (
    GCancellable $cancellable,
    CArray[Pointer[GError]] $error = gerror()
  ) {
    clear_error;
    my $rc = so tepl_file_metadata_load($!tfm, $cancellable, $error);
    set_error($error);
    $rc;
  }

  method load_async (
    Int() $io_priority,
    GCancellable $cancellable,
    &callback,
    gpointer $user_data = Pointer
  )
    is also<load-async>
  {
    my gint $io = resolve-int($io_priority);
    tepl_file_metadata_load_async(
      $!tfm,
      $io,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method load_finish (
    GAsyncResult $result,
    CArray[Pointer[GError]] $error = gerror()
  )
    is also<load-finish>
  {
    clear_error;
    my $rc = tepl_file_metadata_load_finish($!tfm, $result, $error);
    set_error($error);
    $rc;
  }


  method save (
    GCancellable $cancellable,
    CArray[Pointer[GError]] $error = gerror()
  ) {
    clear_error;
    my $rc = tepl_file_metadata_save($!tfm, $cancellable, $error);
    set_error($error);
    $rc;
  }

  method save_async (
    Int() $io_priority,
    GCancellable $cancellable,
    &callback,
    gpointer $user_data = Pointer
  )
    is also<save-async>
  {
    my gint $io = resolve-int($io_priority);
    tepl_file_metadata_save_async(
      $!tfm,
      $io,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method save_finish (
    GAsyncResult $result,
    CArray[Pointer[GError]] $error = gerror()
  )
    is also<save-finish>
  {
    clear_error;
    my $rc = tepl_file_metadata_save_finish($!tfm, $result, $error);
    set_error($error);
    $rc;
  }

  method set (Str() $key, Str() $value) {
    tepl_file_metadata_set($!tfm, $key, $value);
  }

}
