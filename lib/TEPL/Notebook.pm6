use v6.c;

use GTK::Compat::Types;
use GTK::Raw::Types;
use TEPL::Raw::Types;

use TEPL::Raw::Notebook;

use TEPL::Roles::TabGroup;

use GTK::Notebook;

our TeplNotebookAncestry is export
  where TeplNotebook | TeplTabGroup | NotebookAncestry;

class TEPL::Notebook is also GTK::Notebook {
  also does TEPL::Roles::TabGroup;

  has TeplNotebook $!tn;

  method bless(*%attrinit) {
    my $o = self.CREATE.BUILDALL(Empty, %attrinit);
    $o.setType(self.^name);
    $o;
  }

  submethod BUILD (:$notebook) {
    given $notebook {
      when TeplNotebookAncestry {
        my $to-parent;
        $!tn = do {
          when TeplNotebook {
            $to-parent = cast(GtkNotebook, $_);
            $_;
          }
          when TeplTabGroup {
            $!ttg = $_;                           # TEPL::Roles::TabGroup
            $to-parent = cast(GtkGrid, $_);
            cast(TeplNotebook, $_);
          }
          default {
            $to-parent = $_;
            nativecast(TeplNotebook, $_);
          }
        };
        $!ttg //= cast(TeplTabGroup, $!tt);      # TEPL::Roles::TabGroup
        self.setNotebook($to-parent);
      }
      when TEPL::Notebook {
      }
      default {
      }
    }
  }

  method TEPL::Raw::Types::Notebook { $!tn }

  multi method notebook(TeplNotebookAncestry $notebook) {
    my $o = self.bless(:$notebook);
    $o.upref;
  }
  method new {
    self.bless( notebook => tepl_notebook_new() );
  }

  method get_type {
    state ($n, $t)
    unstable_get_type( self.^name, &tepl_notebook_get_type, $n, $t );
  }

}
