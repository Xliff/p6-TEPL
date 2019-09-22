use v6.c;

use NativeCall;
use Method::Also;

use GTK::Compat::Types;
use GTK::Raw::Types;
use TEPL::Raw::Types;

class TEPL::Utils {

  method get_line_indentation (GtkTextIter() $iter) {
    tepl_iter_get_line_indentation($iter)
  }

  method append_edit_actions (GtkMenuShell() $menu_shell) {
    tepl_append_edit_actions($menu_shell);
  }

  method new {
    warn 'TEPL::Utils is a static class and cannot be instantiated.';
    
    TEPL::Utils;
  }

}

sub tepl_append_edit_actions (GtkMenuShell $menu_shell)
  is native(tepl)
  is export
{ * }

sub tepl_iter_get_line_indentation (GtkTextIter $iter)
  returns Str
  is native(tepl)
  is export
{ * }

sub tepl_menu_shell_append_edit_actions (GtkMenuShell $menu_shell)
  is native(tepl)
  is export
{ * }
