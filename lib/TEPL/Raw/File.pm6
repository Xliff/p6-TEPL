use v6.c;

use NativeCall;

use GTK::Compat::Types;
use TEPL::Raw::Types;

unit package TEPL::Raw::File;

# Semi-private files listed in header, but not accessible to NativeCall
#
# sub _tepl_file_create_mount_operation (TeplFile $file)
#   returns GMountOperation
#   is native(tepl)
#   is export
#   { * }
#
# sub _tepl_file_get_etag (TeplFile $file)
#   returns Str
#   is native(tepl)
#   is export
#   { * }
#
# sub _tepl_file_set_compression_type (TeplFile $file, TeplCompressionType $compression_type)
#   is native(tepl)
#   is export
#   { * }
#
# sub _tepl_file_set_deleted (TeplFile $file, gboolean $deleted)
#   is native(tepl)
#   is export
#   { * }
#
# sub _tepl_file_set_encoding (TeplFile $file, TeplEncoding $encoding)
#   is native(tepl)
#   is export
#   { * }
#
# sub _tepl_file_set_etag (TeplFile $file, gchar $etag)
#   is native(tepl)
#   is export
#   { * }
#
# sub _tepl_file_set_externally_modified (TeplFile $file, gboolean $externally_modified)
#   is native(tepl)
#   is export
#   { * }
#
# sub _tepl_file_set_mounted (TeplFile $file)
#   is native(tepl)
#   is export
#   { * }
#
# sub _tepl_file_set_newline_type (TeplFile $file, TeplNewlineType $newline_type)
#   is native(tepl)
#   is export
#   { * }
#
# sub _tepl_file_set_readonly (TeplFile $file, gboolean $readonly)
#   is native(tepl)
#   is export
#   { * }

sub tepl_file_add_uri_to_recent_manager (TeplFile $file)
  is native(tepl)
  is export
  { * }

sub tepl_file_check_file_on_disk (TeplFile $file)
  is native(tepl)
  is export
  { * }

sub tepl_file_get_compression_type (TeplFile $file)
  returns uint32 # TeplCompressionType
  is native(tepl)
  is export
  { * }

sub tepl_file_get_encoding (TeplFile $file)
  returns TeplEncoding
  is native(tepl)
  is export
  { * }

sub tepl_file_get_file_metadata (TeplFile $file)
  returns TeplFileMetadata
  is native(tepl)
  is export
  { * }

sub tepl_file_get_location (TeplFile $file)
  returns GFile
  is native(tepl)
  is export
  { * }

sub tepl_file_get_newline_type (TeplFile $file)
  returns uint32 # TeplNewlineType
  is native(tepl)
  is export
  { * }

sub tepl_file_get_short_name (TeplFile $file)
  returns Str
  is native(tepl)
  is export
  { * }

sub tepl_file_is_deleted (TeplFile $file)
  returns uint32
  is native(tepl)
  is export
  { * }

sub tepl_file_is_externally_modified (TeplFile $file)
  returns uint32
  is native(tepl)
  is export
  { * }

sub tepl_file_is_local (TeplFile $file)
  returns uint32
  is native(tepl)
  is export
  { * }

sub tepl_file_is_readonly (TeplFile $file)
  returns uint32
  is native(tepl)
  is export
  { * }

sub tepl_file_new ()
  returns TeplFile
  is native(tepl)
  is export
  { * }

sub tepl_file_set_location (TeplFile $file, GFile $location)
  is native(tepl)
  is export
  { * }

sub tepl_file_set_mount_operation_factory (
  TeplFile $file,
  &callback (TeplFile, Pointer --> GMountOperation),
  gpointer $user_data,
  GDestroyNotify $notify
)
  is native(tepl)
  is export
  { * }
