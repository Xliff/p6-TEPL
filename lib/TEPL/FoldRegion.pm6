use v6.c;

use Method::Also;

use GTK::Compat::Types;
use GTK::Raw::Types;
use TEPL::Raw::Types;

use GTK::Raw::Utils;

use TEPL::Raw::FoldRegion;

use GLib::Roles::Object;

use TEPL::Buffer;

subset BufferOrObject of Mu where GTK::TextBuffer | TeplBuffer | GtkTextBuffer;

subset IterOrObject of Mu where GTK::TextIter | GtkTextIter;

class TEPL::FoldRegion {
  also does GLib::Roles::Object;

  has TeplFoldRegion $!fr;

  submethod BUILD (:$region) {
    self!setObject($!fr = $region);
  }

  method new (
    BufferOrObject $buffer is copy,
    IterOrObject $start    is copy,
    IterOrObject $end      is copy
  ) {
    $buffer .= TextBuffer if $buffer ~~ GTK::TextBuffer;
    $start  .= TextIter   if $start  ~~ GTK::TextIter;
    $end    .= TextIter   if $end    ~~ GTK::TextIter;
    self.bless( region => tepl_fold_region_new($buffer, $start, $end) );
  }

  method folded is rw {
    Proxy.new(
      FETCH => sub ($) {
        so tepl_fold_region_get_folded($!fr);
      },
      STORE => sub ($, Int() $folded is copy) {
        my gboolean $f = resolve-bool($folded);
        tepl_fold_region_set_folded($!fr, $folded);
      }
    );
  }

  method get_bounds (GtkTextIter() $start, GtkTextIter() $end)
    is also<get-bounds>
  {
    tepl_fold_region_get_bounds($!fr, $start, $end);
  }

  method get_buffer
    is also<
      get-buffer
      buffer
    >
  {
    TEPL::Buffer.new( tepl_fold_region_get_buffer($!fr) );
  }

  method set_bounds (GtkTextIter() $start, GtkTextIter() $end)
    is also<set-bounds>
  {
    tepl_fold_region_set_bounds($!fr, $start, $end);
  }

}
