use v6.c;

use NativeCall;

use TEPL::Raw::Types;

unit package TEPL::Raw::Buffer;

# Semi-Private and not available to NativeCall
#
# sub _tepl_buffer_has_invalid_chars (TeplBuffer $buffer)
#   returns uint32
#   is native(tepl)
#   is export
#   { * }
#
# sub _tepl_buffer_set_as_invalid_character (TeplBuffer $buffer, GtkTextIter $start, GtkTextIter $end)
#   is native(tepl)
#   is export
#   { * }

sub tepl_buffer_get_file (TeplBuffer $buffer)
  returns TeplFile
  is native(tepl)
  is export
  { * }

sub tepl_buffer_get_full_title (TeplBuffer $buffer)
  returns Str
  is native(tepl)
  is export
  { * }

sub tepl_buffer_get_selection_type (TeplBuffer $buffer)
  returns TeplSelectionType
  is native(tepl)
  is export
  { * }

sub tepl_buffer_get_short_title (TeplBuffer $buffer)
  returns Str
  is native(tepl)
  is export
  { * }

sub tepl_buffer_get_style_scheme_id (TeplBuffer $buffer)
  returns Str
  is native(tepl)
  is export
  { * }

sub tepl_buffer_is_untouched (TeplBuffer $buffer)
  returns uint32
  is native(tepl)
  is export
  { * }

sub tepl_buffer_new ()
  returns TeplBuffer
  is native(tepl)
  is export
  { * }

sub tepl_buffer_set_style_scheme_id (
  TeplBuffer $buffer,
  Str $style_scheme_id
)
  is native(tepl)
  is export
  { * }
