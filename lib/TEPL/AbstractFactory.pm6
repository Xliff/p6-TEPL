use v6.c;

use Method::Also;

use GTK::Compat::Types;
use GTK::Raw::Types;
use TEPL::Raw::Types;

use TEPL::Raw::AbstractFactory;

use GLib::Roles::Object;

use GTK::Application;

class TEPL::AbstractFactory {
  also does GLib::Roles::Object;

  has TeplAbstractFactory $!af;

  method TEPL::Raw::Types::TeplAbstractFactory
    is also<
      TeplAbstractFactory
      AbstractFactory
    >
  { $!af }

  # method _unref_singleton {
  #   _tepl_abstract_factory_unref_singleton($!af);
  # }

  proto method set_singleton (|)
    is also<set-singleton>
  { * }

  multi method set_singleton (
    TEPL::AbstractFactory:U:
    TeplAbstractFactory() $factory
  ) {
    tepl_abstract_factory_set_singleton($factory);
    self.bless( :$factory );
  }
  multi method set_singleton (
    TEPL::AbstractFactory:D:
    TeplAbstractFactory() $factory
  ) {
    tepl_abstract_factory_set_singleton($factory);
    $!af = $factory;
  }

  method singleton is rw {
    Proxy.new:
      FETCH => -> $                             { self },
      STORE => -> $, TeplAbstractFactory() \val { self.set_singleton(val) };
  }

  method create_file is also<create-file> {
    tepl_abstract_factory_create_file($!af);
  }

  method create_main_window (GtkApplication() $app)
    is also<create-main-window>
  {
    tepl_abstract_factory_create_main_window($!af, $app);
  }

  method create_tab is also<create-tab> {
    tepl_abstract_factory_create_tab($!af);
  }

  method create_tab_label (TeplTab() $tab) is also<create-tab-label> {
    tepl_abstract_factory_create_tab_label($!af, $tab);
  }

  method get_singleton is also<get-singleton> {
    tepl_abstract_factory_get_singleton();
  }

  method get_type is also<get-type> {
    tepl_abstract_factory_get_type();
  }

}
