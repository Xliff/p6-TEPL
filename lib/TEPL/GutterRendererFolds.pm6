use v6.c;

use NativeCall;
use Method::Also;

use TEPL::Raw::Types;

use GLib::Roles::Object;

class TEPL::GutterRendererFolds {
  also does GLib::Roles::Object;

  has TeplGutterRendererFolds $!grf;

  submethod BUILD (:$folds) {
    self!setObject($!grf = $folds);
  }

  multi method new (TeplGutterRendererFolds $folds) {
    $folds ?? self.bless(:$folds) !! Nil;
  }
  multi method new {
    my $folds = tepl_gutter_renderer_folds_new();

    $folds ?? self.bless(:$folds) !! Nil;
  }

  method set_state (Int() $state) is also<set-state> {
    my guint $s = $state;
    
    tepl_gutter_renderer_folds_set_state($!grf, $s);
  }

}

sub tepl_gutter_renderer_folds_new ()
  returns GtkSourceGutterRenderer
  is native(tepl)
  is export
  { * }

sub tepl_gutter_renderer_folds_set_state (
  TeplGutterRendererFolds $self,
  uint32 $state # TeplGutterRendererFoldsState $state
)
  is native(tepl)
  is export
  { * }
