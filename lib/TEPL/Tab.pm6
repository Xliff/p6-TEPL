use v6.c;

use Method::Also;

use GTK::Compat::Types;
use GTK::Raw::Types;
use TEPL::Raw::Types;

use TEPL::Raw::Tab;

use GTK::Grid;
use TEPL::Buffer;
use TEPL::View;

use GTK::Roles::Signals::Generic;
use TEPL::Roles::TabGroup;

our subset TeplTabAncestry is export
  where TeplTab | TeplTabGroup | GridAncestry;

class TEPL::Tab is GTK::Grid {
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
    is also<
      TeplTab
      Tab
    >
  { $!tt }

  multi method new (TeplTabAncestry $tab) {
    my $o = self.bless(:$tab);
    $o.upref;
  }
  multi method new {
    self.bless( tab => tepl_tab_new() );
  }

  method new_with_view (TeplView() $view) is also<new-with-view> {
    self.bless( tab => tepl_tab_new_with_view($view) );
  }

  # Is originally:
  # TeplTab, gpointer --> void
  method close-request is also<close_request> {
    self.connect($!tt, 'close-request');
  }

  method add_info_bar (GtkInfoBar() $info_bar) is also<add-info-bar> {
    tepl_tab_add_info_bar($!tt, $info_bar);
  }

  method get_buffer
    is also<
      get-buffer
      buffer
    >
  {
    TEPL::Buffer.new( tepl_tab_get_buffer($!tt) );
  }

  method get_type is also<get-type> {
    state ($n, $t);
    unstable_get_type( self.^name, &tepl_tab_get_type, $n, $t );
  }

  method get_view is also<get-view> {
    TEPL::View.new( tepl_tab_get_view($!tt) );
  }

  method load_file (GFile() $location) is also<load-file> {
    tepl_tab_load_file($!tt, $location);
  }

  method save_as_async (
    &callback,
    gpointer $user_data = gpointer
  )
    is also<save-as-async>
  {
    tepl_tab_save_as_async($!tt, &callback, $user_data);
  }

  method save_as_async_simple is also<save-as-async-simple> {
    tepl_tab_save_as_async_simple($!tt);
  }

  method save_as_finish (GAsyncResult() $result) is also<save-as-finish> {
    so tepl_tab_save_as_finish($!tt, $result);
  }

  method save_async (
    &callback,
    gpointer $user_data = gpointer
  )
    is also<save-async>
  {
    tepl_tab_save_async($!tt, &callback, $user_data);
  }

  method save_async_simple is also<save-async-simple> {
    tepl_tab_save_async_simple($!tt);
  }

  method save_finish (GAsyncResult() $result) is also<save-finish> {
    so tepl_tab_save_finish($!tt, $result);
  }

}
