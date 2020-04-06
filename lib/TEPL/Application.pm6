use v6.c;

use TEPL::Raw::Types;
use TEPL::Raw::Application;

use GLib::Roles::Object;

use GTK::Application;
use GTK::ApplicationWindow;
use AMTK;

class TEPL::Application {
  also does GLib::Roles::Object;

  has TeplApplication $!ta;

  submethod BUILD (:$app) {
    self!setObject($!ta = $app);
  }

  method get_default {
    my $app = tepl_application_get_default();

    $app ?? self.bless(:$app) !! TeplApplication;
  }

  method get_from_gtk_application (GtkApplication() $app) {
    my $a = tepl_application_get_from_gtk_application($app);

    $a ?? self.bless(:$a) !! TeplApplication;
  }

  method get_active_main_window (:$raw = False) {
    my $app = tepl_application_get_active_main_window($!ta);

    $app ??
      ( $raw ?? $app !! GTK::ApplicationWindow.new($app) )
      !!
      GtkApplication;
  }

  method get_app_action_info_store (:$raw = False) {
    my $ais = tepl_application_get_app_action_info_store($!ta);

    $ais ??
      ( $raw ?? $ais !! AMTK::ActionInfoStore.new($ais) )
      !!
      AmtkActionInfoStore;
  }

  method get_application (:$raw = False)  {
    my $gtk-app = tepl_application_get_application($!ta);

    $gtk-app ??
      ( $raw ?? $gtk-app !! GTK::Application.new($gtk-app) )
      !!
      GtkApplication;
  }

  method get_tepl_action_info_store (:$raw = False) {
    my $tais = tepl_application_get_tepl_action_info_store($!ta);

    $tais ??
      ( $raw ?? $tais !! AMTK::ActionInfoStore.new($tais) )
      !!
      AmtkActionInfoStore;
  }

  method get_type {
    state ($n, $t);
    unstable_get_type( self.^name, &tepl_application_get_type, $n, $t );
  }

  method handle_activate {
    tepl_application_handle_activate($!ta);
  }

  method handle_open {
    tepl_application_handle_open($!ta);
  }

  method open_simple (GFile() $file) {
    tepl_application_open_simple($!ta, $file);
  }

}
