use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GIO::Raw::Definitions;
use AMTK::Raw::Definitions;
use GTK::Raw::Definitions;
use TEPL::Raw::Definitions;

unit package TEPL::Raw::Application;

### /usr/src/tepl-6.4.0/tepl/tepl-application.h\

sub tepl_application_get_active_main_window (
  TeplApplication $tepl_app
)
  returns GtkApplicationWindow
  is      native(tepl)
  is      export
{ * }

sub tepl_application_get_app_action_info_store (
  TeplApplication $tepl_app
)
  returns AmtkActionInfoStore
  is      native(tepl)
  is      export
{ * }

sub tepl_application_get_application (
  TeplApplication $tepl_app
)
  returns GtkApplication
  is      native(tepl)
  is      export
{ * }

sub tepl_application_get_default ()
  returns TeplApplication
  is      native(tepl)
  is      export
{ * }

sub tepl_application_get_from_gtk_application (
  GtkApplication $gtk_app
)
  returns TeplApplication
  is      native(tepl)
  is      export
{ * }

sub tepl_application_get_tepl_action_info_store (
  TeplApplication $tepl_app
)
  returns AmtkActionInfoStore
  is      native(tepl)
  is      export
{ * }

sub tepl_application_get_type ()
  returns GType
  is      native(tepl)
  is      export
{ * }

sub tepl_application_handle_activate (TeplApplication $tepl_app)
  is native(tepl)
  is export
{ * }

sub tepl_application_handle_open (TeplApplication $tepl_app)
  is native(tepl)
  is export
{ * }

sub tepl_application_open_simple (
  TeplApplication $tepl_app,
  GFile           $file
)
  is native(tepl)
  is export
{ * }
