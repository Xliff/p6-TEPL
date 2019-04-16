use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GTK::Raw::Types;
use TEPL::Raw::Types;

unit package TEPL::Raw::ApplicationWindow;

sub tepl_application_window_get_application_window (
  TeplApplicationWindow $tepl_window
)
  returns GtkApplicationWindow
  is native(tepl)
  is export
  { * }

sub tepl_application_window_get_from_gtk_application_window (
  GtkApplicationWindow $gtk_window
)
  returns TeplApplicationWindow
  is native(tepl)
  is export
  { * }

sub tepl_application_window_get_type ()
  returns GType
  is native(tepl)
  is export
  { * }

sub tepl_application_window_get_window_group (
  TeplApplicationWindow $tepl_window
)
  returns GtkWindowGroup
  is native(tepl)
  is export
  { * }

sub tepl_application_window_is_main_window (
  GtkApplicationWindow $gtk_window
)
  returns uint32
  is native(tepl)
  is export
  { * }

sub tepl_application_window_open_file (
  TeplApplicationWindow $tepl_window, 
  GFile $location, 
  gboolean $jump_to
)
  is native(tepl)
  is export
  { * }

sub tepl_application_window_set_tab_group (
  TeplApplicationWindow $tepl_window, 
  TeplTabGroup $tab_group
)
  is native(tepl)
  is export
  { * }

sub tepl_application_window_get_handle_title (
  TeplApplicationWindow $tepl_window
)
  returns uint32
  is native(tepl)
  is export
  { * }

sub tepl_application_window_set_handle_title (
  TeplApplicationWindow $tepl_window, 
  gboolean $handle_title
)
  is native(tepl)
  is export
  { * }
