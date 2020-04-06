use v6.c;

use Method::Also;

use TEPL::Raw::Types;
use TEPL::Raw::AbstractFactory;

use GTK::Application;

use GLib::Roles::Object;

class TEPL::AbstractFactory {
  also does GLib::Roles::Object;

  has TeplAbstractFactory $!af is implementor;

  submethod BUILD (:$factory) {
    self.setAbastractFactory($factory);
  }

  method setAbastractFactory(TeplAbstractFactory $factory) {
    $!af = $factory;

    self.roleInit-Object;
  }

  method TEPL::Raw::Types::TeplAbstractFactory
    is also<
      TeplAbstractFactory
      AbstractFactory
    >
  { $!af }

  # method _unref_singleton {
  #   _tepl_abstract_factory_unref_singleton($!af);
  # }

  method new (TeplAbstractFactory $factory) {
    $factory ?? self.bless(:$factory) !! TeplAbstractFactory;
  }

  proto method set_singleton (|)
    is also<set-singleton>
  { * }

  multi method set_singleton (
    TEPL::AbstractFactory:U:
    TeplAbstractFactory() $factory
  ) {
    return TeplAbstractFactory unless $factory;

    tepl_abstract_factory_set_singleton($factory);
    self.setTeplAbstractFactory($factory);
  }
  multi method set_singleton (
    TEPL::AbstractFactory:D:
    TeplAbstractFactory() $factory
  ) {
    tepl_abstract_factory_set_singleton($factory);
    self.setTeplAbstractFactory($factory);
  }

  method singleton (TEPL::AbstractFactory:U:) is rw {
    Proxy.new:
      FETCH => sub ($)                          { self },
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

  method get_singleton (:$raw = False) is also<get-singleton> {
    my $factory = tepl_abstract_factory_get_singleton();

    return TeplAbstractFactory unless $factory;
    self.setTeplAbstractFactory($factory) unless $!af;

    $raw ?? $factory !! self;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &tepl_abstract_factory_get_type, $n, $t );
  }

}
