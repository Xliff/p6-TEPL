use v6.c;

use Method::Also;

use GTK::Compat::Types;
use TEPL::Raw::Types;

use TEPL::Raw::Encoding;

# BOXED TYPE

class TEPL::Encoding {
  has TeplEncoding $!te;

  submethod BUILD (:$encoding) {
    $!te = $encoding;
  }

  method TEPL::Raw::Types::TeplEncoding { $!te }

  multi method new (TeplEncoding $encoding) {
    self.bless(:$encoding);
  }
  multi method new(
    :$locale,
    :$utf8
  ) {
    die ':locale and :utf8 options cannot be used at the same time!'
      if $locale.defined && $utf8.defined;

    $locale ??
      self.new_from_locale !!
      $utf8 ??
        self.new_utf8 !!
        self.bless( encoding => tepl_encoding_new() );
  }

  method new_from_locale is also<new-from-locale> {
    self.bless( encoding => tepl_encoding_new_from_locale($!tb) );
  }

  method new_utf8 is also<new-utf8> {
    self.bless( encoding => tepl_encoding_new_utf8($!tb) );
  }

  method to_string
    is also<
      to-string
      Str
    >
  {
    tepl_encoding_to_string($!tb);
  }

  method copy {
    self.bless( encoding => tepl_encoding_copy($!tb) );
  }

  method equals (TeplEncoding $enc2) {
    so tepl_encoding_equals($!tb, $enc2);
  }

  method free {
    tepl_encoding_free($!tb);
  }

  method get_all
    is also<
      get-all
      all
    >
  {
    tepl_encoding_get_all();
  }

  method get_charset
    is also<
      get-charset
      charset
    >
  {
    my $l = GTK::Compat::GSList.new( tepl_encoding_get_charset($!tb) )
      but ListData[TeplEncoding];
    $l.Array.map({ TEPL::Encoding.new($_) });
  }

  method get_default_candidates
    is also<
      get-default-candidates
      default_candidates
      default-candidates
    >
  {
    my $l = GTK::Compat::GSList.new(
      tepl_encoding_get_default_candidates()
    ) but ListData[TeplEncoding];
    $l.Array.map({ TEPL::Encoding.new($_) });
  }

  method get_name
    is also<
      get-name
      name
    >
  {
    tepl_encoding_get_name($!tb);
  }

  method get_type is also<get-type> {
    state ($n, $t);
    unstable_get_type( self.^name, &tepl_encoding_get_type, $n, $t );
  }

  method is_utf8 is also<is-utf8> {
    tepl_encoding_is_utf8($!tb);
  }

}

sub infix:<=:=> (TEPL::Encoding $a, TEPL::Encoding) $b is export {
  $a.TeplEncoding.p == $b.TeplEncoding.p
}
sub infix:<eqv> (TeplEncoding $a, TeplEncoding $b) is export {
  so tepl_encoding_equals($a, $b);
}
