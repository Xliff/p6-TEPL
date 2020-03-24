use v6.c;

use Method::Also;

use TEPL::Raw::Types;
use TEPL::Raw::InfoBar;

use GTK::InfoBar;
use GTK::Label;

our subset TeplInfoBarAncestry is export of Mu
  where TeplInfoBar | InfoBarAncestry;

class TEPL::InfoBar is GTK::InfoBar {
  has TeplInfoBar $!tib;

  method bless(*%attrinit) {
    my $o = self.CREATE.BUILDALL(Empty, %attrinit);
    $o.setType($o.^name);
    $o;
  }

  submethod BUILD (:$teplinfobar) {
    self.setTeplInfoBar($teplinfobar) if $teplinfobar;
  }

  method setTeplInfoBar (TeplInfoBarAncestry $_) {
    my $to-parent;
    $!tib = do {
      when TeplInfoBar {
        $to-parent = cast(GtkInfoBar, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(TeplInfoBar, $_);
      }
    }
    self.setInfoBar($to-parent);
  }

  method TEPL::Raw::Types::TeplInfoBar
    is also<TeplInfoBar>
  { $!tib }

  method new {
    my $teplinfobar = tepl_info_bar_new();

    $teplinfobar ?? self.bless(:$teplinfobar) !! Nil;
  }

  method new_simple (Int() $msg_type, Str() $primary_msg, Str() $secondary_msg)
    is also<new-simple>
  {
    my guint $mt = $msg_type;
    my $teplinfobar = tepl_info_bar_new_simple(
      $mt,
      $primary_msg,
      $secondary_msg
    );

    $teplinfobar ?? self.bless(:$teplinfobar) !! Nil;
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

  method create_label (:$raw = False) is also<create-label> {
    my $l = tepl_info_bar_create_label();

    $l ??
      ( $raw ?? $l !! GTK::Label.new($l) )
      !!
      GtkLabel;
  }

}
