use v6.c;

use TEPL::Raw::Types;
use TEPL::Raw::TabGroup;

use TEPL::View;
use TEPL::Buffer;

use GLib::Roles::ListData;

role TEPL::Roles::TabGroup {
  has TeplTabGroup $!ttg;

  method active-tab is rw {
    Proxy.new:
      FETCH => sub ($)              { self.get_active_tab },
      STORE => -> $, TeplTab() $val { self.set_active_tab($val) };
  }

  method append_tab (TeplTab() $tab, Int() $jump_to) {
    my gboolean $j = $jump_to.so.Int;

    tepl_tab_group_append_tab($!ttg, $tab, $j);
  }

  method get_active_buffer (:$raw = False) {
    my $tb = tepl_tab_group_get_active_buffer($!ttg);

    $tb ??
      ( $raw ?? $tb !! TEPL::Buffer.new($tb) )
      !!
      TeplBuffer;
  }

  method get_active_tab (:$raw = False) {
    my $tg = tepl_tab_group_get_active_tab($!ttg);

    $tg ??
      ( $raw ?? $tg !! ::('TEPL::Tab').new($tg) )
      !!
      TeplTab;
  }

  method get_active_view (:$raw = False) {
    my $v = tepl_tab_group_get_active_view($!ttg);

    $v ??
      ( $raw ?? $v !! TEPL::View.new($v) )
      !!
      TeplView;
  }

  method get_buffers (:$glist = False, :$raw = False) {
    my $l = tepl_tab_group_get_buffers($!ttg);

    return Nil unless $l;
    return $l  if $glist;

    $l = GTK::Compat::List.new($l) but GLib::Roles::ListData[TeplTab];
    $raw ?? $l.Array !! $l.Array.map({ TEPL::Buffer.new($_) });
  }

  method get_tabs (:$glist = False, :$raw = False) {
    my $l = tepl_tab_group_get_tabs($!ttg);

    return Nil unless $l;
    return $l  if $glist;

    $l = GTK::Compat::List.new($l) but GLib::Roles::ListData[TeplTab];
    $raw ?? $l.Array !! $l.Array.map({ TEPL::Tab.new($_) });
  }

  method get_tabgroup_type {
    state ($n, $t);

    unstable_get_type( self.^name, &tepl_tab_group_get_type, $n, $t );
  }

  method get_views (:$glist = False, :$raw = False) {
    my $l = tepl_tab_group_get_views($!ttg);

    return Nil unless $l;
    return $l  if $glist;

    $l = GTK::Compat::List.new($l) but GLib::Roles::ListData[TeplView];
    $raw ?? $l.Array !! $l.Array.map({ TEPL::View.new($_) });
  }

  method set_active_tab (TeplTab() $tab) {
    tepl_tab_group_set_active_tab($!ttg, $tab);
  }

}
