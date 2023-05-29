use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GTK::Raw::Definitions;
use TEPL::Raw::Definitions;

unit package TEPL::Raw::InfoBar;

###/usr/src/tepl/tepl/tepl-info-bar.h

sub tepl_info_bar_add_close_button (TeplInfoBar $info_bar)
  is native(tepl)
  is export
{ * }

sub tepl_info_bar_add_content_widget (
  TeplInfoBar $info_bar,
  GtkWidget   $content
)
  is native(tepl)
  is export
{ * }

sub tepl_info_bar_add_icon (TeplInfoBar $info_bar)
  is native(tepl)
  is export
{ * }

sub tepl_info_bar_add_primary_message (
  TeplInfoBar $info_bar,
  Str         $primary_msg
)
  is native(tepl)
  is export
{ * }

sub tepl_info_bar_add_secondary_message (
  TeplInfoBar $info_bar,
  Str         $secondary_msg
)
  is native(tepl)
  is export
{ * }

sub tepl_info_bar_create_label ()
  returns GtkLabel
  is      native(tepl)
  is      export
{ * }

sub tepl_info_bar_new ()
  returns TeplInfoBar
  is      native(tepl)
  is      export
{ * }

sub tepl_info_bar_new_simple (
  uint32 $msg_type,  # GtkMessageType $msg_type,
  Str    $primary_msg,
  Str    $secondary_msg
)
  returns TeplInfoBar
  is      native(tepl)
  is      export
{ * }
