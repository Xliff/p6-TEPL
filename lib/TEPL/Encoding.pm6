use v6.c;

use Method::Also;

use GTK::Compat::Types;
use TEPL::Raw::Types;

use GTK::Compat::Roles::ListData;

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
    :$charset,
    :$locale,
    :$utf8
  ) {
    die ':charset, :locale and :utf8 options cannot be used at the same time!'
      if [&&]($charset.defined, $locale.defined, $utf8.defined);

    $locale ??
      self.new_from_locale !!
      $utf8 ??
        self.new_utf8 !!
        self.bless( encoding => tepl_encoding_new($charset) );
  }

  method new_from_locale is also<new-from-locale> {
    self.bless( encoding => tepl_encoding_new_from_locale() );
  }

  method new_utf8 is also<new-utf8> {
    self.bless( encoding => tepl_encoding_new_utf8() );
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
    self.bless( encoding => tepl_encoding_copy($!te) );
  }

  method equals (TeplEncoding $enc2) {
    so tepl_encoding_equals($!te, $enc2);
  }

  method free {
    tepl_encoding_free($!te);
  }

  method get_all
    is also<
      get-all
      all
    >
  {
    tepl_encoding_get_all();
  }

  method get_charset (:$raw)
    is also<
      get-charset
      charset
    >
  {
    my $l = GTK::Compat::GSList.new( tepl_encoding_get_charset($!te) )
      but GTK::Compat::Roles::ListData[TeplEncoding];
    $raw ??
      $l.Array !! $l.Array.map({ TEPL::Encoding.new($_) });
  }

  method get_default_candidates (:$raw)
    is also<
      get-default-candidates
      default_candidates
      default-candidates
    >
  {
    my $l = GTK::Compat::GSList.new(
      tepl_encoding_get_default_candidates()
    ) but GTK::Compat::Roles::ListData[TeplEncoding];
    $raw ??
      $l.Array !! $l.Array.map({ TEPL::Encoding.new($_) });
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
    tepl_encoding_is_utf8($!te);
  }

}

sub infix:<=:=> (TEPL::Encoding $a, TEPL::Encoding $b) is export {
  $a.TeplEncoding.p == $b.TeplEncoding.p
}
sub infix:<eqv> (TeplEncoding $a, TeplEncoding $b) is export {
  so tepl_encoding_equals($a, $b);
}
