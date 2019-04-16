use v6.c;

use NativeCall;

use GTK::Compat::Types;
use TEPL::Raw::Types;

unit package TEPL::Raw::TabLabel;

sub tepl_tab_label_get_tab (TeplTabLabel $tab_label)
  returns TeplTab
  is native(tepl)
  is export
  { * }

sub tepl_tab_label_get_type ()
  returns GType
  is native(tepl)
  is export
  { * }

sub tepl_tab_label_new (TeplTab $tab)
  returns GtkWidget
  is native(tepl)
  is export
  { * }

sub tepl_tab_label_update_tooltip (TeplTabLabel $tab_label)
  is native(tepl)
  is export
  { * }
