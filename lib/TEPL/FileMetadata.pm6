use v6.c;

use Method::Also;
use NativeCall;

use TEPL::Raw::Types;
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
    $metadata ?? self.bless(:$metadata) !! Nil;
  }
  multi method new (TeplFile() $file) {
    my $metadata = tepl_file_metadata_new($file);

    $metadata ?? self.bless(:$metadata) !! Nil;
  }

  method get (Str() $key) {
    tepl_file_metadata_get($!tfm, $key);
  }

  method get_file (:$raw = False) is also<get-file> {
    my $tf = tepl_file_metadata_get_file($!tfm);

    $tf ??
      ( $raw ?? $tf !! ::('TEPL::File').new($tf) )
      !!
      TeplFile;
  }

  multi method load (
    CArray[Pointer[GError]] $error = gerror()
  ) {
    samewith(GCancellable, $error);
  }
  multi method load (
    GCancellable() $cancellable,
    CArray[Pointer[GError]] $error = gerror()
  ) {
    clear_error;
    my $rc = so tepl_file_metadata_load($!tfm, $cancellable, $error);
    set_error($error);
    $rc;
  }

  multi method load_async (
    Int() $io_priority,
    &callback,
    gpointer $user_data = Pointer
  ) {
    samewith($io_priority, GCancellable, &callback, $user_data);
  }
  multi method load_async (
    Int() $io_priority,
    GCancellable() $cancellable,
    &callback,
    gpointer $user_data = Pointer
  )
    is also<load-async>
  {
    my gint $io = $io_priority;

    tepl_file_metadata_load_async(
      $!tfm,
      $io,
      $cancellable,
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
    my $rc = so tepl_file_metadata_load_finish($!tfm, $result, $error);
    set_error($error);
    $rc;
  }

  multi method save (
    CArray[Pointer[GError]] $error = gerror()
  ) {
    samewith(GCancellable, $error);
  }
  multi method save (
    GCancellable() $cancellable,
    CArray[Pointer[GError]] $error = gerror()
  ) {
    clear_error;
    my $rc = so tepl_file_metadata_save($!tfm, $cancellable, $error);
    set_error($error);
    $rc;
  }

  proto method save_async (|)
    is also<save-async>
  { * }

  multi method save_async (
    Int() $io_priority,
    &callback,
    gpointer $user_data = Pointer
  ) {
    samewith($io_priority, GCancellable, &callback, $user_data);
  }
  multi method save_async (
    Int() $io_priority,
    GCancellable() $cancellable,
    &callback,
    gpointer $user_data = Pointer
  ) {
    my gint $io = $io_priority;

    tepl_file_metadata_save_async(
      $!tfm,
      $io,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method save_finish (
    GAsyncResult() $result,
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
