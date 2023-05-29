use v6.c;

use Method::Also;

use NativeCall;

use TEPL::Raw::Types;

use GTK::Bin;

use GLib::Roles::Implementor;

our subset TeplLineColumnIndicatorAncestry is export of Mu
  where TeplLineColumnIndicator | GtkBinAncestry;

class TEPL::LineColumn::Indicator is GTK::Bin {
  has TeplLineColumnIndicator $!t-lci is implementor;

  submethod BUILD ( :$tepl-lc-indicator ) {
    self.setTeplLineColumnIndicator($tepl-lc-indicator)
      if $tepl-lc-indicator
  }

  method setTeplLineColumnIndicator (TeplLineColumnIndicatorAncestry $_) {
    my $to-parent;

    $!t-lci = do {
      when TeplLineColumnIndicator {
        $to-parent = cast(GtkBin, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(TeplLineColumnIndicator, $_);
      }
    }
    self.setGtkBin($to-parent);
  }

  method TEPL::Raw::Definitions::TeplLineColumnIndicator
    is also<TeplLineColumnIndicator>
  { $!t-lci }

  multi method new (
     $tepl-lc-indicator where * ~~ TeplLineColumnIndicatorAncestry,

    :$ref = True
  ) {
    return unless $tepl-lc-indicator;

    my $o = self.bless( :$tepl-lc-indicator );
    $o.ref if $ref;
    $o;
  }
  multi method new ( *%a ) {
    my $tepl-lc-indicator = tepl_line_column_indicator_new();

    my $o = $tepl-lc-indicator ?? self.bless( :$tepl-lc-indicator ) !! Nil;
    for %a.keys {
      given .key {
        when 'tab_group' | 'tab-group'          { $o.set_tab_group( .value ) }
        when 'tepl_view' | 'tepl-view' | 'view' { $o.set_tab_view(  .value ) }

        default {
          say "Invalid attribute '{ .key }' for LineColumnIndicator.{
               '' }  Ignored!"
        }
      }
    }
    $o;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &tepl_line_column_indicator_get_type,
      $n,
      $t
    );
  }

  method set_tab_group (TeplTabGroup() $tab_group) is also<set-tab-group> {
    tepl_line_column_indicator_set_tab_group($!t-lci, $tab_group);
  }

  method set_view (TeplView() $view) is also<set-view> {
    tepl_line_column_indicator_set_view($!t-lci, $view);
  }

}

### /usr/src/tepl-6.4.0/tepl/tepl-line-column-indicator.h

sub tepl_line_column_indicator_get_type
  returns GType
  is      native(tepl)
  is      export
{ * }

sub tepl_line_column_indicator_new
  returns TeplLineColumnIndicator
  is      native(tepl)
  is      export
{ * }

sub tepl_line_column_indicator_set_tab_group (
  TeplLineColumnIndicator $indicator,
  TeplTabGroup            $tab_group
)
  is      native(tepl)
  is      export
{ * }

sub tepl_line_column_indicator_set_view (
  TeplLineColumnIndicator $indicator,
  TeplView                $view
)
  is      native(tepl)
  is      export
{ * }
