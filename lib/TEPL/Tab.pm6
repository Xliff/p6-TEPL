use v6.c;

use GTK::Compat::Types;
use GTK::Raw::Types;
use TEPL::Raw::Types;

use TEPL::Raw::Tab;

use GTK::Grid;
use TEPL::Buffer;
use TEPL::View;

use GTK::Roles::Signals::Generic;
use TEPL::Roles::TabGroup;

our TeplTabAncestry is export
  where TeplTabl | TeplTabGroup | GridAncestry;

class TEPL::TabLabel is also GTK::Grid {
  also does GTK::Roles::Signals::Generic;
  also does TEPL::Roles::TabGroup;

  has TeplTab $!tt;

  method bless(*%attrinit) {
    my $o = self.CREATE.BUILDALL(Empty, %attrinit);
    $o.setType(self.^name);
    $o;
  }

  submethod BUILD (:$tab) {
    given $tab {
      when TeplTabAncestry {
        my $to-parent;
        $!tt = do {
          when TeplTab {
            $to-parent = cast(GtkGrid, $_);
            $_;
          }
          when TeplTabGroup {
            $!ttg = $_;
            $to-parent = cast(GtkGrid, $_);      # TEPL::Roles::TabGroup
            cast(TeplTab, $_);
          }
          default {
            $to-parent = $_;
            cast(TeplTab, $_);
          }
        };
        $!ttg //= cast(TeplTabGroup, $!tt);      # TEPL::Roles::TabGroup
        self.setGrid($to-parent);
      }
      when TEPL::Tab {
      }
      default {
      }
    }
  }

  method TEPL::Raw::TeplTab
    #is also<TeplTab>
  { $!tt }

  # Is originally:
  # TeplTab, gpointer --> void
  method close-request {
    self.connect($!tt, 'close-request');
  }

  multi method new (TeplTabAncestry $tab) {
    my $o = self.bless(:$tab);
    $o.upref;
  }
  method new {
    self.bless( tab => tepl_tab_new() );
  }

  method new_with_view (TeplView() $view) {
    self.bless( tab => tepl_tab_new_with_view($view) );
  }

  method add_info_bar (GtkInfoBar() $info_bar) {
    tepl_tab_add_info_bar($!ttl, $info_bar);
  }

  method get_buffer {
    TEPL::Buffer.new( tepl_tab_get_buffer($!ttl) );
  }

  method get_type {
    state ($n, $t);
    unstable_get_type( self.^name. &tepl_tab_get_type, $n, $t );
  }

  method get_view {
    TEPL::View.new( tepl_tab_get_view($!ttl) );
  }

  method load_file (GFile() $location) {
    tepl_tab_load_file($!ttl, $location);
  }

  method save_as_async (
    &callback,
    gpointer $user_data = Pointer
  ) {
    tepl_tab_save_as_async($!ttl, &callback, $user_data);
  }

  method save_as_async_simple {
    tepl_tab_save_as_async_simple($!ttl);
  }

  method save_as_finish (GAsyncResult $result) {
    so tepl_tab_save_as_finish($!ttl, $result);
  }

  method save_async (
    &callback,
    gpointer $user_data = Pointer
  ) {
    tepl_tab_save_async($!ttl, &callback, $user_data);
  }

  method save_async_simple {
    tepl_tab_save_async_simple($!ttl);
  }

  method save_finish (GAsyncResult $result) {
    so tepl_tab_save_finish($!ttl, $result);
  }

}
