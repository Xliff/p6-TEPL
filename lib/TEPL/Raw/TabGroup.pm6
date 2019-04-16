use v6.c;

use NativeCall;

use GTK::Compat::Types;
use TEPL::Raw::Types;

unit package TEPL::Raw::TabGroup;

sub tepl_tab_group_append_tab (
  TeplTabGroup $tab_group,
  TeplTab $tab,
  gboolean $jump_to
)
  is native(tepl)
  is export
  { * }

sub tepl_tab_group_get_active_buffer (TeplTabGroup $tab_group)
  returns TeplBuffer
  is native(tepl)
  is export
  { * }

sub tepl_tab_group_get_active_tab (TeplTabGroup $tab_group)
  returns TeplTab
  is native(tepl)
  is export
  { * }

sub tepl_tab_group_get_active_view (TeplTabGroup $tab_group)
  returns TeplView
  is native(tepl)
  is export
  { * }

sub tepl_tab_group_get_buffers (TeplTabGroup $tab_group)
  returns GList
  is native(tepl)
  is export
  { * }

sub tepl_tab_group_get_tabs (TeplTabGroup $tab_group)
  returns GList
  is native(tepl)
  is export
  { * }

sub tepl_tab_group_get_type ()
  returns GType
  is native(tepl)
  is export
  { * }

sub tepl_tab_group_get_views (TeplTabGroup $tab_group)
  returns GList
  is native(tepl)
  is export
  { * }

sub tepl_tab_group_set_active_tab (TeplTabGroup $tab_group, TeplTab $tab)
  is native(tepl)
  is export
  { * }
