use v6.c;

use TEPL::Raw::Types;
use TEPL::Raw::ApplicationWindow;

use GTK::ApplicationWindow;
use GTK::WindowGroup;

use GLib::Roles::Object;

class TEPL::ApplicationWindow {
  also does GLib::Roles::Object;

  has TeplApplicationWindow $!taw;

  submethod BUILD (:$window) {
    self!setObject($!taw = $window);
  }

  multi method new (TeplApplicationWindow $window, :$ref = True) {
    return TeplApplicationWindow unless $window;

    my $o = self.bless(:$window);
    $o.upref if $ref;
    $o;
  }

  method handle_title is rw {
    Proxy.new(
      FETCH => sub ($) {
        so tepl_application_window_get_handle_title($!taw);
      },
      STORE => sub ($, Int() $handle_title is copy) {
        my gboolean $h = $handle_title.so.Int;

        tepl_application_window_set_handle_title($!taw, $h);
      }
    );
  }


  method get_application_window (:$raw = False) {
    my $aw = tepl_application_window_get_application_window($!taw);

    $aw ??
      ( $raw ?? $aw !! GTK::ApplicationWindow.new($aw) )
      !!
      TeplApplicationWindow;
  }

  method get_from_gtk_application_window (
    TEPL::ApplicationWindow:U:
    GtkWindow() $gtk-w,
    :$raw = False
  ) {
    my $tw = tepl_application_window_get_from_gtk_application_window($gtk-w);

    $tw ??
      ( $raw ?? $tw !! TEPL::ApplicationWindow.new($tw, :!ref) )
      !!
      TeplApplicationWindow;
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &tepl_application_window_get_type, $n, $t );
  }

  method get_window_group (:$raw = False) {
    my $wg = tepl_application_window_get_window_group($!taw);

    $wg ??
      ( $raw ?? $wg !! GTK::WindowGroup.new($wg) )
      !!
      GtkWindowGroup;
  }

  method is_main_window {
    so tepl_application_window_is_main_window(
      cast(GtkApplicationWindow, $!taw)
    );
  }

  method open_file (GFile() $location, Int() $jump_to) {
    my gboolean $j = $jump_to.so.Int;

    tepl_application_window_open_file($!taw, $location, $j);
  }

  method set_tab_group (TeplTabGroup() $tab_group) {
    tepl_application_window_set_tab_group($!taw, $tab_group);
  }

}
