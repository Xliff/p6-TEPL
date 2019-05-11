use v6.c;

use Method::Also;

use GTK::Compat::Types;
use SourceViewGTK::Raw::Types;
use TEPL::Raw::Types;

use TEPL::Raw::Buffer;

use SourceViewGTK::Buffer;

use TEPL::File;

our subset TeplBufferAncestry is export
  where TeplBuffer | SourceBufferAncestry;

class TEPL::Buffer is SourceViewGTK::Buffer {
  has TeplBuffer $!tb;

  method bless(*%attrinit) {
    my $o = self.CREATE.BUILDALL(Empty, %attrinit);
    $o.setType(self.^name);
    $o;
  }

  submethod BUILD (:$buffer) {
    given $buffer {
      when TeplBufferAncestry {
        my $to-parent;
        $!tb = do {
          when TeplBuffer {
            $to-parent = cast(GtkSourceBuffer, $_);
            $_;
          }
          default {
            $to-parent = $_;
            cast(TeplBuffer, $_);
          }
        }
        self.setSourceBuffer($to-parent);
      }
      when SourceViewGTK::Buffer {
      }
      default {
      }
    }
  }

  method TEPL::Raw::Types::TeplBuffer is also<TeplBuffer> { $!tb }

  multi method new(TeplBufferAncestry $buffer) {
    my $o = self.bless($buffer);
    $o.upref;
  }
  multi method new {
    self.bless( buffer => tepl_buffer_new() );
  }

  method get_file
    is also<
      get-file
      file
    >
  {
    TEPL::File.new( tepl_buffer_get_file($!tb) );
  }

  method get_full_title
    is also<
      get-full-title
      full_title
      full-title
    >
  {
    tepl_buffer_get_full_title($!tb);
  }

  method get_selection_type
    is also<
      get-selection-type
      selection_type
      selection-type
    >
  {
    TeplSelectionType( tepl_buffer_get_selection_type($!tb) );
  }

  method get_short_title
    is also<
      get-short-title
      short_title
      short-title
    >
  {
    tepl_buffer_get_short_title($!tb);
  }

  method is_untouched is also<is-untouched> {
    so tepl_buffer_is_untouched($!tb);
  }

}
