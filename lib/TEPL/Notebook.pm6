use v6.c;

use Method::Also;

use TEPL::Raw::Types;
use TEPL::Raw::Notebook;

use TEPL::Roles::TabGroup;

use GTK::Notebook;

our subset TeplNotebookAncestry is export
  where TeplNotebook | TeplTabGroup | NotebookAncestry;

class TEPL::Notebook is GTK::Notebook {
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
            cast(TeplNotebook, $_);
          }
        };
        $!ttg //= cast(TeplTabGroup, $!tn);       # TEPL::Roles::TabGroup
        self.setNotebook($to-parent);
      }

      when TEPL::Notebook {
      }

      default {
      }
    }
  }

  method TEPL::Raw::Types::Notebook
    is also<
      TeplNotebook
      Notebook
    >
  { $!tn }

  multi method notebook(TeplNotebookAncestry $notebook, :$ref = True) {
    return Nil unless $notebook;

    my $o = self.bless(:$notebook);
    $o.ref if $ref;
    $o;
  }
  method new {
    my $notebook = tepl_notebook_new();

    $notebook ?? self.bless( :$notebook ) !! Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &tepl_notebook_get_type, $n, $t );
  }

}
