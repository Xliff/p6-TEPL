use v6.c;

use GTK::Compat::Types;
use TEPL::Raw::Types;

use TEPL::Raw::TabGroup;

use TEPL::View;
use TEPL::Buffer;

use GTK::Compat::Roles::ListData;

role TEPL::Roles::TabGroup {
  has TeplTabGroup $!ttg;

  method active-tab is rw {
    Proxy.new:
      FETCH => -> $                 { self.get_active_tab },
      STORE => -> $, TeplTab() $val { self.set_active_tab($val) };
  }

  method append_tab (TeplTab() $tab, gboolean $jump_to) {
    tepl_tab_group_append_tab($!ttg, $tab, $jump_to);
  }

  method get_active_buffer {
    TEPL::Buffer.new( tepl_tab_group_get_active_buffer($!ttg) );
  }

  method get_active_tab {
    tepl_tab_group_get_active_tab($!ttg);
  }

  method get_active_view {
    TEPL::View.new( tepl_tab_group_get_active_view($!ttg) );
  }

  method get_buffers (:$raw = False) {
    my $l = GTK::Compat::List.new( tepl_tab_group_get_buffers($!ttg) )
      but GTK::Compat::Roles::ListData[TeplTab];
    $raw ??
      $l.Array !! $l.Array.map({ TEPL::Buffer.new($_) });
  }

  method get_tabs (:$raw = False) {
    my $l = GTK::Compat::List.new( tepl_tab_group_get_tabs($!ttg) )
      but GTK::Compat::Roles::ListData[TeplTab];
    $raw ??
      $l.Array !! $l.Array.map({ TEPL::Tab.new($_) });
  }

  method get_tabgroup_type {
    state ($n, $t);
    unstable_get_type( self.^name, &tepl_tab_group_get_type, $n, $t );
  }

  method get_views (:$raw = False) {
    my $l = GTK::Compat::List.new( tepl_tab_group_get_views($!ttg) )
      but GTK::Compat::Roles::ListData[TeplView];
    $raw ??
      $l.Array !! $l.Array.map({ TEPL::View.new($_) });
  }

  method set_active_tab (TeplTab() $tab) {
    tepl_tab_group_set_active_tab($!ttg, $tab);
  }

}
