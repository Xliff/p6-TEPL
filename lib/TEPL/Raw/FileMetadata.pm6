use v6.c;

use NativeCall;

use GTK::Compat::Types;
use TEPL::Raw::Types;

unit package TEPL::Raw::FileMetadata;

# Included in header, but not available to NativeCall
#
# sub _tepl_file_metadata_set_use_gvfs_metadata (TeplFileMetadata $metadata, gboolean $use_gvfs_metadata)
#   is native(tepl)
#   is export
#   { * }

sub tepl_file_metadata_get (TeplFileMetadata $metadata, Str $key)
  returns Str
  is native(tepl)
  is export
  { * }

sub tepl_file_metadata_get_file (TeplFileMetadata $metadata)
  returns TeplFile
  is native(tepl)
  is export
  { * }

sub tepl_file_metadata_load (
  TeplFileMetadata $metadata,
  GCancellable $cancellable,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(tepl)
  is export
  { * }

sub tepl_file_metadata_load_async (
  TeplFileMetadata $metadata,
  gint $io_priority,
  GCancellable $cancellable,
  GAsyncReadyCallback $callback,
  gpointer $user_data
)
  is native(tepl)
  is export
  { * }

sub tepl_file_metadata_load_finish (
  TeplFileMetadata $metadata,
  GAsyncResult $result,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(tepl)
  is export
  { * }

sub tepl_file_metadata_new (TeplFile $file)
  returns TeplFileMetadata
  is native(tepl)
  is export
  { * }

sub tepl_file_metadata_save (
  TeplFileMetadata $metadata,
  GCancellable $cancellable,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(tepl)
  is export
  { * }

sub tepl_file_metadata_save_async (
  TeplFileMetadata $metadata,
  gint $io_priority,
  GCancellable $cancellable,
  GAsyncReadyCallback $callback,
  gpointer $user_data
)
  is native(tepl)
  is export
  { * }

sub tepl_file_metadata_save_finish (
  TeplFileMetadata $metadata,
  GAsyncResult $result,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(tepl)
  is export
  { * }

sub tepl_file_metadata_set (TeplFileMetadata $metadata, Str $key, Str $value)
  is native(tepl)
  is export
  { * }
