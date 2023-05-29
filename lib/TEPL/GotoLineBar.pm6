use v6.c;

use Method::Also;

use NativeCall;

use TEPL::Raw::Types;

use GTK::Grid;

use GLib::Roles::Implementor;

our subset TeplGotoLineBarAncestry is export of Mu
  where TeplGotoLineBar | GtkGridAncestry;

class TEPL::GotoLineBar is GTK::Grid {
  has TeplGotoLineBar $!t-glb is implementor;

  submethod BUILD ( :$tepl-goto-bar ) {
    self.setTeplGotoLineBar($tepl-goto-bar) if $tepl-goto-bar
  }

  method setTeplGotoLineBar (TeplGotoLineBarAncestry $_) {
    my $to-parent;

    $!t-glb = do {
      when TeplGotoLineBar {
        $to-parent = cast(GtkGrid, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(TeplGotoLineBar, $_);
      }
    }
    self.setGtkGrid($to-parent);
  }

  method TEPL::Raw::Definitions::TeplGotoLineBar
    is also<TeplGotoLineBar>
  { $!t-glb }

  multi method new (
     $tepl-goto-bar where * ~~ TeplGotoLineBarAncestry,

    :$ref = True
  ) {
    return unless $tepl-goto-bar;

    my $o = self.bless( :$tepl-goto-bar );
    $o.ref if $ref;
    $o;
  }
  method new {
    my $tepl-goto-bar = tepl_goto_line_bar_new();

    $tepl-goto-bar ?? self.bless( :$tepl-goto-bar ) !! Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(self.^name &tepl_goto_line_bar_get_type, $n, $t );
  }

  method grab_focus_to_entry is also<grab-focus-to-entry> {
    tepl_goto_line_bar_grab_focus_to_entry($!t-glb);
  }

  method set_view (TeplView() $view) is also<set-view> {
    tepl_goto_line_bar_set_view($!t-glb, $view);
  }

}

### /usr/src/tepl-6.4.0/tepl/tepl-goto-line-bar.h

sub tepl_goto_line_bar_get_type
  returns GType
  is      native(tepl)
  is      export
{ * }

sub tepl_goto_line_bar_grab_focus_to_entry (TeplGotoLineBar $bar)
  is      native(tepl)
  is      export
{ * }

sub tepl_goto_line_bar_new
  returns TeplGotoLineBar
  is      native(tepl)
  is      export
{ * }

sub tepl_goto_line_bar_set_view (
  TeplGotoLineBar $bar,
  TeplView        $view
)
  is      native(tepl)
  is      export
{ * }
