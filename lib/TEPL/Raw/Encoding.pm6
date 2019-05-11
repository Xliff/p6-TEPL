use v6.c;

use NativeCall;

use GTK::Compat::Types;
use TEPL::Raw::Types;

unit package TEPL::Raw::Encoding;

sub tepl_encoding_copy (TeplEncoding $enc)
  returns TeplEncoding
  is native(tepl)
  is export
  { * }

sub tepl_encoding_equals (TeplEncoding $enc1, TeplEncoding $enc2)
  returns uint32
  is native(tepl)
  is export
  { * }

sub tepl_encoding_free (TeplEncoding $enc)
  is native(tepl)
  is export
  { * }

sub tepl_encoding_get_all ()
  returns GSList
  is native(tepl)
  is export
  { * }

sub tepl_encoding_get_charset (TeplEncoding $enc)
  returns Str
  is native(tepl)
  is export
  { * }

sub tepl_encoding_get_default_candidates ()
  returns GSList
  is native(tepl)
  is export
  { * }

sub tepl_encoding_get_name (TeplEncoding $enc)
  returns Str
  is native(tepl)
  is export
  { * }

sub tepl_encoding_get_type ()
  returns GType
  is native(tepl)
  is export
  { * }

sub tepl_encoding_is_utf8 (TeplEncoding $enc)
  returns uint32
  is native(tepl)
  is export
  { * }

sub tepl_encoding_new (Str $charset)
  returns TeplEncoding
  is native(tepl)
  is export
  { * }

sub tepl_encoding_new_from_locale ()
  returns TeplEncoding
  is native(tepl)
  is export
  { * }

sub tepl_encoding_new_utf8 ()
  returns TeplEncoding
  is native(tepl)
  is export
  { * }

sub tepl_encoding_to_string (TeplEncoding $enc)
  returns Str
  is native(tepl)
  is export
  { * }
