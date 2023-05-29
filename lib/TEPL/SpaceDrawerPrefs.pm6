use v6.c;

use Method::Also;

use NativeCall;

use TEPL::Raw::Types;

use GTK::Grid;
use SourceViewGTK::SpaceDrawer;

our subset TeplSpaceDrawerPrefsAncestry is export of Mu
  where TeplSpaceDrawerPrefs | GtkGridAncestry;

class TEPL::SpaceDrawerPrefs is GTK::Grid {
  has TeplSpaceDrawerPrefs $!t-sdp is implementor;

  submethod BUILD ( :$tepl-drawer-prefs ) {
    self.setTeplSpaceDrawerPrefs($tepl-drawer-prefs) if $tepl-drawer-prefs;
  }

  method setTeplSpaceDrawerPrefs (TeplSpaceDrawerPrefsAncestry $_) {
    my $to-parent;

    $!t-sdp = do {
      when TeplSpaceDrawerPrefs {
        $to-parent = cast(GtkGrid, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(TeplSpaceDrawerPrefs, $_);
      }
    }
    self.setGtkGrid($to-parent);
  }

  method TEPL::Raw::Definitions::TeplSpaceDrawerPrefs
    is also<TeplSpaceDrawerPrefs>
  { $!t-sdp }

  multi method new (
     $tepl-drawer-prefs where * ~~ TeplSpaceDrawerPrefsAncestry,

    :$ref = True
  ) {
    return unless $tepl-drawer-prefs;

    my $o = self.bless( :$tepl-drawer-prefs );
    $o.ref if $ref;
    $o;
  }
  multi method new {
    my $tepl-drawer-prefs = tepl_space_drawer_prefs_new();

    $tepl-drawer-prefs ?? self.bless( :$tepl-drawer-prefs ) !! Nil;
  }

  method get_space_drawer ( :$raw = False )
    is also<
      get-space-drawer
      space_drawer
      space-drawer
    >
  {
    propReturnObject(
      tepl_space_drawer_prefs_get_space_drawer($!t-sdp),
      $raw,
      |SourceViewGTK::SpaceDrawer.getTypePair
    );
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &tepl_space_drawer_prefs_get_type,
      $n,
      $t
    );
  }

}





### /usr/src/tepl-6.4.0/tepl/tepl-space-drawer-prefs.h

sub tepl_space_drawer_prefs_get_space_drawer (TeplSpaceDrawerPrefs $prefs)
  returns GtkSourceSpaceDrawer
  is      native(tepl)
  is      export
{ * }

sub tepl_space_drawer_prefs_get_type
  returns GType
  is      native(tepl)
  is      export
{ * }

sub tepl_space_drawer_prefs_new
  returns TeplSpaceDrawerPrefs
  is      native(tepl)
  is      export
{ * }
