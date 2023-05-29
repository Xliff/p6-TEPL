use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GTK::Raw::Definitions;
use TEPL::Raw::Definitions;

unit package TEPL::Raw::AbstractFactory;

### /usr/src/tepl/tepl/tepl-abstract-factory.h

sub _tepl_abstract_factory_unref_singleton ()
  is native(tepl)
  is export
{ * }

sub tepl_abstract_factory_create_file (TeplAbstractFactory $factory)
  returns TeplFile
  is native(tepl)
  is export
{ * }

sub tepl_abstract_factory_create_main_window (
  TeplAbstractFactory $factory,
  GtkApplication      $app
)
  returns GtkApplicationWindow
  is native(tepl)
  is export
{ * }

sub tepl_abstract_factory_create_tab (TeplAbstractFactory $factory)
  returns TeplTab
  is native(tepl)
  is export
{ * }

sub tepl_abstract_factory_create_tab_label (
  TeplAbstractFactory $factory,
  TeplTab $tab
)
  returns GtkWidget
  is native(tepl)
  is export
{ * }

sub tepl_abstract_factory_get_singleton ()
  returns TeplAbstractFactory
  is native(tepl)
  is export
{ * }

sub tepl_abstract_factory_get_type ()
  returns GType
  is native(tepl)
  is export
{ * }

sub tepl_abstract_factory_set_singleton (TeplAbstractFactory $factory)
  is native(tepl)
  is export
{ * }
