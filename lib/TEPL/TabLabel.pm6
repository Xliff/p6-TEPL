use v6.c;

use GTK::Compat::Types;
use TEPL::Raw::Types;

use TEPL::Raw::TabLabel;

use GTK::Grid;
use TEPL::Tab;

our TeplTabLabelAncestry is export
  where TeplTabLabel | GridAncestry;

class TEPL::TabLabel is also GTK::Grid {
  has TeplTabLabel $!ttl;

  method bless(*%attrinit) {
    my $o = self.CREATE.BUILDALL(Empty, %attrinit);
    $o.setType(self.^name);
    $o;
  }

  submethod BUILD (:$tablabel) {
    given $tablabel {
      when TeplTabLabelAncestry {
        my $to-parent;
        $!ttl = do {
          when TeplTabLabel {
            $to-parent = cast(GtkGrid, $_);
            $_;
          }
          default {
            $to-parent = $_;
            cast(TeplTabLabel, $_;
          }
        };
        self.setGrid($to-parent);
      }
      when TEPL::TabLabel {
      }
      default {
      }
    }
  }

  method TEPL::Raw::Types::TeplTabLabel
    is also<TeplTabLabel>
  { $!ttl }

  multi method new (TeplTabLabelAncestry $tablabel) {
    my $o = self.bless(:$tablabel);
    $o.upref;
  }
  multi method new {
    self.bless( tablabel => tepl_tab_label_new() );
  }

  method get_tab
    is also<
      get-tab
      tab
    >
  {
    TEPL::Tab.new( tepl_tab_label_get_tab($!ttl) );
  }

  method get_type is also<get-type> {
    state ($n, $t);
    unstable_get_type( self.^name, &tepl_tab_label_get_type, $n, $t );
  }

  method update_tooltip is also<update-tooltip> {
    tepl_tab_label_update_tooltip($!ttl);
  }
}
