use v6.c;

use Method::Also;

use GTK::Compat::Types;
use GTK::Raw::Types;
use TEPL::Raw::Types;

use TEPL::Raw::InfoBar;

use GTK::InfoBar;
use GTK::Label;

class TEPL::Infobar is GTK::InfoBar {
  has TeplInfoBar $!tib;

  method bless(*%attrinit) {
    my $o = self.CREATE.BUILDALL(Empty, %attrinit);
    $o.setType($o.^name);
    $o;
  }

  submethod BUILD (:$teplinfobar) {
    self.setInfobar( cast(GtkInfoBar, $!tib = $teplinfobar) );
  }

  method TEPL::Raw::Types::TeplInfoBar
    is also<TeplInfoBar>
  { $!tib }

  method new {
    self.bless( teplinfobar => tepl_info_bar_new() );
  }

  method new_simple (Str() $primary_msg, Str() $secondary_msg)
    is also<new-simple>
  {
    self.bless(
      teplinfobar => tepl_info_bar_new_simple(
        $!tib, $primary_msg, $secondary_msg
      )
    );
  }

  method add_close_button is also<add-close-button> {
    tepl_info_bar_add_close_button($!tib);
  }

  method add_content_widget (GtkWidget() $content)
    is also<add-content-widget>
  {
    tepl_info_bar_add_content_widget($!tib, $content);
  }

  method add_icon is also<add-icon> {
    tepl_info_bar_add_icon($!tib);
  }

  method add_primary_message (Str() $primary_msg)
    is also<add-primary-message>
  {
    tepl_info_bar_add_primary_message($!tib, $primary_msg);
  }

  method add_secondary_message (Str() $secondary_msg)
    is also<add-secondary-message>
  {
    tepl_info_bar_add_secondary_message($!tib, $secondary_msg);
  }

  method create_label is also<create-label> {
    GTK::Label.new( tepl_info_bar_create_label() );
  }

}
