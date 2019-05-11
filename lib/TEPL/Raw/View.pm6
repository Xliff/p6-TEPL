use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GTK::Raw::Types;
use TEPL::Raw::Types;

unit package TEPL::Raw::View;

sub tepl_view_copy_clipboard (TeplView $view)
  is native(tepl)
  is export
  { * }

sub tepl_view_cut_clipboard (TeplView $view)
  is native(tepl)
  is export
  { * }

sub tepl_view_delete_selection (TeplView $view)
  is native(tepl)
  is export
  { * }

sub tepl_view_goto_line (TeplView $view, gint $line)
  returns uint32
  is native(tepl)
  is export
  { * }

sub tepl_view_goto_line_offset (TeplView $view, gint $line, gint $line_offset)
  returns uint32
  is native(tepl)
  is export
  { * }

sub tepl_view_new ()
  returns GtkWidget
  is native(tepl)
  is export
  { * }

sub tepl_view_paste_clipboard (TeplView $view)
  is native(tepl)
  is export
  { * }

sub tepl_view_scroll_to_cursor (TeplView $view)
  is native(tepl)
  is export
  { * }

sub tepl_view_select_all (TeplView $view)
  is native(tepl)
  is export
  { * }

sub tepl_view_select_lines (TeplView $view, gint $start_line, gint $end_line)
  is native(tepl)
  is export
  { * }
