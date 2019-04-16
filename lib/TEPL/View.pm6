use v6.c;

use GTK::Compat::Types;
use SourceViewGTK::Raw::Types;
use TEPL::Raw::Types;

use TEPL::Raw::View;

use SourceViewGTK::View;

our TeplViewAncestry is export
  where TeplView | SourceViewAncestry;

class TEPL::View is SourceViewGTK::View {
  has TeplView $!tv;

  method bless(*%attrinit) {
    my $o = self.CREATE.BUILDALL(Empty, %attrinit);
    $o.setType(self.^name);
    $o;
  }

  submethod BUILD (:$view) {
    given $view {
      when TeplViewAncestry {
        my $to-parent;
        $!tv = do {
          when TeplView {
            $to-parent = cast(GtkSourceView, $_);
            $_;
          }
          default {
            $to-parent = $_;
            cast(TeplView, $_);
          }
        }
        self.setSourceView($to-parent);
      }
      when TEPL::View {
      }
      default {
      }
    }
  }

  method TEPL::Raw::Types::TeplView is also<TeplView> { $!tv }

  multi method new (TeplView $view) {
    my $o = self.bless(:$view);
    $o.upref;
  }
  multi method new {
    self.bless( view => tepl_view_new() );
  }

  method copy_clipboard {
    tepl_view_copy_clipboard($!tv);
  }

  method cut_clipboard {
    tepl_view_cut_clipboard($!tv);
  }

  method delete_selection {
    tepl_view_delete_selection($!tv);
  }

  method goto_line (Int() $line) {
    my gint $l = self.RESOLVE-INT($line);
    so tepl_view_goto_line($!tv, $l);
  }

  method goto_line_offset (Int() $line, Int() $line_offset) {
    my gint ($l, $lo) = self.RESOLVE-INT($line, $line_offset);
    so tepl_view_goto_line_offset($!tv, $line, $line_offset);
  }

  method paste_clipboard {
    tepl_view_paste_clipboard($!tv);
  }

  method scroll_to_cursor {
    tepl_view_scroll_to_cursor($!tv);
  }

  method select_all {
    tepl_view_select_all($!tv);
  }

  method select_lines (Int() $start_line, Int() $end_line) {
    my gint ($sl, $el) = self.RESOLVE-INT($start_line, $end_line);
    tepl_view_select_lines($!tv, $sl, $el);
  }


}
