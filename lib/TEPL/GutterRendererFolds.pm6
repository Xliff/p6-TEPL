use v6.c;

use NativeCall;
use Method::Also;

use GTK::Compat::Types;
use SourceViewGTK::Raw::Types;
use TEPL::Raw::Types;

use GTK::Raw::Utils;

use GTK::Compat::Roles::Object;

class TEPL::GutterRendererFolds {
  also does GTK::Compat::Roles::Object;

  has TeplGutterRendererFolds $!grf;

  submethod BUILD (:$folds) {
    self!setObject($!grf = $folds);
  }

  method new {
    tepl_gutter_renderer_folds_new();
  }

  method set_state (Int() $state) is also<set-state> {
    my guint $s = resolve-int($state);
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
