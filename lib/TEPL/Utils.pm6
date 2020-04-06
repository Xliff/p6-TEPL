use v6.c;

use NativeCall;
use Method::Also;

use TEPL::Raw::Types;

use GLib::Roles::StaticClass;

class TEPL::Utils {
  also does GLib::Roles::StaticClass;

  method get_line_indentation (GtkTextIter() $iter) {
    tepl_iter_get_line_indentation($iter)
  }

  method append_edit_actions (GtkMenuShell() $menu_shell) {
    tepl_append_edit_actions($menu_shell);
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
