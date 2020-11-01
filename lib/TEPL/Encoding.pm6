use v6.c;

use Method::Also;

use TEPL::Raw::Types;
use TEPL::Raw::Encoding;

use GLib::Roles::ListData;

# BOXED TYPE

class TEPL::Encoding {
  has TeplEncoding $!te;

  submethod BUILD (:$encoding) {
    $!te = $encoding;
  }

  method TEPL::Raw::Types::TeplEncoding
    is also<TeplEncoding>
  { $!te }

  multi method new (TeplEncoding $encoding) {
    $encoding ?? self.bless(:$encoding) !! Nil;
  }
  multi method new (Str() $charset) {
    my $encoding = tepl_encoding_new($charset);

    $encoding ?? self.bless(:$encoding) !! Nil;
  }

  multi method new (:$locale is required) {
    self.new_from_locale;
  }
  method new_from_locale is also<new-from-locale> {
    my $encoding = tepl_encoding_new_from_locale();

    $encoding ?? self.bless(:$encoding) !! Nil;
  }

  multi method new (:$utf8 is required) {
    self.new_utf8;
  }
  method new_utf8 is also<new-utf8> {
    my $encoding = tepl_encoding_new_utf8();

    $encoding ?? self.bless(:$encoding) !! Nil;
  }

  method to_string
    is also<
      to-string
      Str
    >
  {
    tepl_encoding_to_string($!te);
  }

  method copy {
    my $encoding = tepl_encoding_copy($!te);

    $encoding ?? TEPL::Encoding.new($encoding) !! TeplEncoding;
  }

  method equals (TeplEncoding $enc2) {
    so tepl_encoding_equals($!te, $enc2);
  }

  method free {
    tepl_encoding_free($!te);
  }

  method !process-returned-list($l, :$glist, :$raw) {
    return Nil unless $l;
    return $l  if $glist;

    # GSList is still ill, so using GList
    $l = GList::GList.new($l) but GLib::Roles::ListData[TeplEncoding];
    $raw ?? $l.Array !! $l.Array.map({ TEPL::Encoding.new($_) });
  }

  method get_all (:$glist = False, :$raw = False)
    is also<
      get-all
      all
    >
  {
    self!process-returned-list( tepl_encoding_get_all(), :$glist, $raw );
  }

  method get_charset (:$glist = False, :$raw = False)
    is also<
      get-charset
      charset
    >
  {
    self!process-returned-list(
      tepl_encoding_get_charset($!te),
      :$glist,
      :$raw
    );
  }

  method get_default_candidates (:$glist = False, :$raw = False)
    is also<
      get-default-candidates
      default_candidates
      default-candidates
    >
  {
    self!process-returned-list(
      tepl_encoding_get_default_candidates(),
      $glist,
      $raw
    );
  }

  method get_name
    is also<
      get-name
      name
    >
  {
    tepl_encoding_get_name($!te);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &tepl_encoding_get_type, $n, $t );
  }

  method is_utf8 is also<is-utf8> {
    so tepl_encoding_is_utf8($!te);
  }

}

multi sub infix:<=:=> (TEPL::Encoding $a, TEPL::Encoding $b) is export {
  +$a.TeplEncoding.p == +$b.TeplEncoding.p
}
multi sub infix:<eqv> (TeplEncoding $a, TeplEncoding $b) is export {
  so tepl_encoding_equals($a, $b);
}
