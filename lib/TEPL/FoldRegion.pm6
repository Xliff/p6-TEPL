use v6.c;

use Method::Also;

use TEPL::Raw::Types;
use TEPL::Raw::FoldRegion;

use GTK::TextBuffer;
use GTK::TextIter;

use GLib::Roles::Object;

subset BufferOrObject of Mu
  where GTK::TextBuffer | TeplBuffer | GtkTextBuffer;

subset IterOrObject of Mu
  where GTK::TextIter | GtkTextIter;

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

    my $region = tepl_fold_region_new($buffer, $start, $end);

    $region ?? self.bless(:$region) !! Nil;
  }

  method folded is rw {
    Proxy.new(
      FETCH => sub ($) {
        so tepl_fold_region_get_folded($!fr);
      },
      STORE => sub ($, Int() $folded is copy) {
        my gboolean $f = $folded.so.Int;

        tepl_fold_region_set_folded($!fr, $f);
      }
    );
  }

  proto method get_bounds (|)
    is also<get-bounds>
  { * }

  multi method get_bounds {
    samewith(GtkTextIter.new, GtkTextIter.new);
  }
  multi method get_bounds (
    GtkTextIter $start is rw,
    GtkTextIter $end   is rw,
    :$raw = False
  ) {
    die 'Both $start and $end must be defined!'
      unless $start && $end;

    tepl_fold_region_get_bounds($!fr, $start, $end);

    $raw ?? ($start // GtkTextIter, $end // GtkTextIter)
         !! ( GTK::TextIter.new($start), GTK::TextIter.new($end) );
  }

  method get_buffer (:$raw = False, :$gtk = False)
    is also<
      get-buffer
      buffer
    >
  {
    my $b = tepl_fold_region_get_buffer($!fr);

    $b ??
      ( $raw ?? $b
             !! ($gtk ?? GTK::Buffer.new($b) !! TEPL::Buffer.new($b) ) )
      !!
      ( $gtk ?? GtkTextBuffer !! TeplBuffer )
  }

  method set_bounds (GtkTextIter() $start, GtkTextIter() $end)
    is also<set-bounds>
  {
    tepl_fold_region_set_bounds($!fr, $start, $end);
  }

}
