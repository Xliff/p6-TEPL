use v6.c;

use NativeCall;

use GTK::Compat::Types;
use TEPL::Raw::Types;

unit package TEPL::Raw::FileLoader;

sub tepl_file_loader_error_quark ()
  returns GQuark
  is native(tepl)
  is export
  { * }

sub tepl_file_loader_get_buffer (TeplFileLoader $loader)
  returns TeplBuffer
  is native(tepl)
  is export
  { * }

sub tepl_file_loader_get_encoding (TeplFileLoader $loader)
  returns TeplEncoding
  is native(tepl)
  is export
  { * }

sub tepl_file_loader_get_file (TeplFileLoader $loader)
  returns TeplFile
  is native(tepl)
  is export
  { * }

sub tepl_file_loader_get_location (TeplFileLoader $loader)
  returns GFile
  is native(tepl)
  is export
  { * }

sub tepl_file_loader_get_newline_type (TeplFileLoader $loader)
  returns uint32 # TeplNewlineType
  is native(tepl)
  is export
  { * }

sub tepl_file_loader_load_async (
  TeplFileLoader $loader,
  gint $io_priority,
  GCancellable $cancellable,
  Pointer $progress_callback, # GFileProgressCallback,
  gpointer $progress_callback_data,
  GDestroyNotify $progress_callback_notify,
  GAsyncReadyCallback $callback,
  gpointer $user_data
)
  is native(tepl)
  is export
  { * }

sub tepl_file_loader_load_finish (
  TeplFileLoader $loader,
  GAsyncResult $result,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(tepl)
  is export
  { * }

sub tepl_file_loader_new (TeplBuffer $buffer, TeplFile $file)
  returns TeplFileLoader
  is native(tepl)
  is export
  { * }

sub tepl_file_loader_get_chunk_size (TeplFileLoader $loader)
  returns gint64
  is native(tepl)
  is export
  { * }

sub tepl_file_loader_get_max_size (TeplFileLoader $loader)
  returns gint64
  is native(tepl)
  is export
  { * }

sub tepl_file_loader_set_chunk_size (
  TeplFileLoader $loader,
  gint64 $chunk_size
)
  is native(tepl)
  is export
  { * }

sub tepl_file_loader_set_max_size (TeplFileLoader $loader, gint64 $max_size)
  is native(tepl)
  is export
  { * }
