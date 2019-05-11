use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GTK::Raw::Types;
use TEPL::Raw::Types;

unit package TEPL::Raw::Tabs;

sub tepl_tab_add_info_bar (TeplTab $tab, GtkInfoBar $info_bar)
  is native(tepl)
  is export
  { * }

sub tepl_tab_get_buffer (TeplTab $tab)
  returns TeplBuffer
  is native(tepl)
  is export
  { * }

sub tepl_tab_get_type ()
  returns GType
  is native(tepl)
  is export
  { * }

sub tepl_tab_get_view (TeplTab $tab)
  returns TeplView
  is native(tepl)
  is export
  { * }

sub tepl_tab_load_file (TeplTab $tab, GFile $location)
  is native(tepl)
  is export
  { * }

sub tepl_tab_new ()
  returns TeplTab
  is native(tepl)
  is export
  { * }

sub tepl_tab_new_with_view (TeplView $view)
  returns TeplTab
  is native(tepl)
  is export
  { * }

sub tepl_tab_save_as_async (
  TeplTab $tab,
  &callback (Pointer, GAsyncResult, Pointer),
  gpointer $user_data
)
  is native(tepl)
  is export
  { * }

sub tepl_tab_save_as_async_simple (TeplTab $tab)
  is native(tepl)
  is export
  { * }

sub tepl_tab_save_as_finish (TeplTab $tab, GAsyncResult $result)
  returns uint32
  is native(tepl)
  is export
  { * }

sub tepl_tab_save_async (
  TeplTab $tab,
  &callback (Pointer, GAsyncResult, Pointer),
  gpointer $user_data
)
  is native(tepl)
  is export
  { * }

sub tepl_tab_save_async_simple (TeplTab $tab)
  is native(tepl)
  is export
  { * }

sub tepl_tab_save_finish (TeplTab $tab, GAsyncResult $result)
  returns uint32
  is native(tepl)
  is export
  { * }
