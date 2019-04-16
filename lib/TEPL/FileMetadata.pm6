use v6.c;

use GTK::Compat::Types;
use TEPL::Raw::Types;

use TEPL::Raw::FileMetadata;

use GTK::Compat::Roles::Object

class TEPL::FileMetadata {
  also does GTK::Compat::Roles::Object;

  has TeplFileMetadata $!tfm;

  submethod BUILD (:$metadata) {
    self!setObject($!tfm = $metadata);
  }

  method TEPL::Raw::Types::TeplFileMetadata { $!tfm }

  multi method new (TeplFileMetadata $metadata) {
    self.bless(:$metadata);
  }
  method new {
    self.bless( metadata => tepl_file_metadata_new() );
  }

  method get (Str() $key) {
    tepl_file_metadata_get($!tb, $key);
  }

  method get_file {
    ::('TEPL::File').new(tepl_file_metadata_get_file($!tb) );
  }

  method load (
    GCancellable $cancellable,
    CArray[Pointer[GError]] $error = gerror()
  ) {
    clear_error;
    my $rc = so tepl_file_metadata_load($!tb, $cancellable, $error);
    set_error($error);
    $rc;
  }

  method load_async (
    Int() $io_priority,
    GCancellable $cancellable,
    &callback,
    gpointer $user_data = Pointer
  ) {
    my gint $io = resolve-int($io_priority);
    tepl_file_metadata_load_async(
      $!tb,
      $io,
      $cancellable,
      $callback,
      $user_data
    );
  }

  method load_finish (
    GAsyncResult $result,
    CArray[Pointer[GError]] $error = gerror()
  ) {
    clear_error;
    my $rc = tepl_file_metadata_load_finish($!tb, $result, $error);
    set_error($error);
    $rc;
  }


  method save (
    GCancellable $cancellable,
    CArray[Pointer[GError]] $error = gerror()
  ) {
    clear_error;
    my $rc = tepl_file_metadata_save($!tb, $cancellable, $error);
    set_error($error);
    $rc;
  }

  method save_async (
    Int() $io_priority,
    GCancellable $cancellable,
    &callback,
    gpointer $user_data = Pointer
  ) {
    my gint $io = resolve-int($io_priority);
    tepl_file_metadata_save_async(
      $!tb,
      $io,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method save_finish (
    GAsyncResult $result,
    CArray[Pointer[GError]] $error = gerror()
  ) {
    clear_error;
    my $rc = tepl_file_metadata_save_finish($!tb, $result, $error);
    set_error($error);
    $rc;
  }

  method set (Str() $key, Str() $value) {
    tepl_file_metadata_set($!tb, $key, $value);
  }

}
