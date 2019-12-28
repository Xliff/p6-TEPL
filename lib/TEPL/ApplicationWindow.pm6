use v6.c;

use GTK::Compat::Types;
use GTK::Raw::Types;
use TEPL::Raw::Types;

use GTK::Raw::Utils;

use TEPL::Raw::ApplicationWindow;

use GLib::Roles::Object;

use GTK::ApplicationWindow;
use GTK::WindowGroup;

class TEPL::ApplicationWindow {
  also does GLib::Roles::Object;

  has TeplApplicationWindow $!taw;

  submethod BUILD (:$window) {
    self!setObject($!taw = $window);
  }

  multi method new (TeplApplicationWindow $window) {
    my $o = self.bless(:$window);
    $o.upref;
  }

  method handle_title is rw {
    Proxy.new(
      FETCH => sub ($) {
        so tepl_application_window_get_handle_title($!taw);
      },
      STORE => sub ($, Int() $handle_title is copy) {
        my gboolean $h = resolve-bool($handle_title);
        tepl_application_window_set_handle_title($!taw, $h);
      }
    );
  }


  method get_application_window {
    GTK::ApplicationWindow.new(
      tepl_application_window_get_application_window($!taw)
    );
  }

  method get_from_gtk_application_window {
    self.bless(
      window => tepl_application_window_get_from_gtk_application_window(
        cast(GtkApplicationWindow, $!taw)
      )
    );
  }

  method get_type {
    state ($n, $t);
    unstable_get_type( self.^name, &tepl_application_window_get_type, $n, $t );
  }

  method get_window_group {
    GTK::WindowGroup.new( tepl_application_window_get_window_group($!taw) );
  }

  method is_main_window {
    so tepl_application_window_is_main_window(
      cast(GtkApplicationWindow, $!taw)
    );
  }

  method open_file (GFile() $location, Int() $jump_to) {
    my gboolean $j = resolve-bool($jump_to);
    tepl_application_window_open_file($!taw, $location, $j);
  }

  method set_tab_group (TeplTabGroup() $tab_group) {
    tepl_application_window_set_tab_group($!taw, $tab_group);
  }

}
