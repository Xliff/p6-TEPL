use v6.c;

use GTK::Compat::Types;
use GTK::Raw::Types;
use TEPL::Raw::Types;

use TEPL::Raw::Application;

use GTK::Compat::Roles::Object;

#use GTK::ApplicationWindow;
#use AMTK::ActionInfoStore;

class TEPL::Application {
  also does GTK::Compat::Roles::Object;
  
  has TeplApplication $!ta;
  
  submethod BUILD (:$app) {
    self!setObject($!ta = $app);
  }
  
  method get_default {
    self.bless( app => tepl_application_get_default($!ta) );
  }

  method get_from_gtk_application (GtkApplication() $app) {
    self.bless(
      app => tepl_application_get_from_gtk_application($app)
    );
  }
  
  method get_active_main_window {
    #GTK::ApplicationWindow.new(
      tepl_application_get_active_main_window($!ta)
    #)
  }

  method get_app_action_info_store {
    #AMTK::ActionInfoStore.new(
      tepl_application_get_app_action_info_store($!ta);
    #);
  }

  method get_application {
    GTK::Application.new(
      tepl_application_get_application($!ta)
    );
  }

  method get_tepl_action_info_store {
    #AMTK::ActionInfoStore.new(
      tepl_application_get_tepl_action_info_store($!ta)
    #);
  }

  method get_type {
    state ($n, $t);
    unstable_get_tyoe( self.^name, &tepl_application_get_type, $n, $t );
  }

  method handle_activate {
    tepl_application_handle_activate($!ta);
  }

  method handle_open {
    tepl_application_handle_open($!ta);
  }

  method open_simple (GFile $file) {
    tepl_application_open_simple($!ta, $file);
  }

}
  
  
