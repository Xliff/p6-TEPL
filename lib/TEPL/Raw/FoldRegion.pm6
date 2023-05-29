use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GTK::Raw::Definitions;
use GTK::Raw::Structs;
use TEPL::Raw::Definitions;

unit package TEPL::Raw::FoldRegion;

#### /usr/src/tepl/tepl/tepl-fold-region.h

sub tepl_fold_region_get_bounds (
  TeplFoldRegion $fold_region,
  GtkTextIter    $start,
  GtkTextIter    $end
)
  returns uint32
  is      native(tepl)
  is      export
{ * }

sub tepl_fold_region_get_buffer (TeplFoldRegion $fold_region)
  returns GtkTextBuffer
  is      native(tepl)
  is      export
{ * }

sub tepl_fold_region_new (
  GtkTextBuffer $buffer,
  GtkTextIter   $start,
  GtkTextIter   $end
)
  returns TeplFoldRegion
  is      native(tepl)
  is      export
{ * }

sub tepl_fold_region_set_bounds (
  TeplFoldRegion $fold_region,
  GtkTextIter    $start,
  GtkTextIter    $end
)
  is native(tepl)
  is export
{ * }

sub tepl_fold_region_get_folded (TeplFoldRegion $fold_region)
  returns uint32
  is      native(tepl)
  is      export
{ * }

sub tepl_fold_region_set_folded (
  TeplFoldRegion $fold_region,
  gboolean       $folded
)
  is native(tepl)
  is export
{ * }
