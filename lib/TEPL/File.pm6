use v6.c;

use Method::Also;
use NativeCall;

use TEPL::Raw::Types;
use TEPL::Raw::File;

use TEPL::Encoding;
use TEPL::FileMetadata;

use GLib::Roles::Object;
use GIO::Roles::GFile;

class TEPL::File {
  also does GLib::Roles::Object;

  has TeplFile $!tf;

  submethod BUILD (:$file) {
    self!setObject($!tf = $file);                 # GLib::Roles::Object
  }

  method TEPL::Raw::Types::TeplFile
    is also<TeplFile>
  { $!tf }

  multi method new (TeplFile $file) {
    $file ?? self.bless(:$file) !! Nil;
  }
  multi method new {
    my $file = tepl_file_new();

    $file ?? self.bless(:$file) !! Nil;
  }

  method location is rw {
    Proxy.new:
      FETCH => sub ($)            { self.get_location      },
      STORE => -> $, GFile() \val { self.set_location(val) };
  }

  method add_uri_to_recent_manager  is also<add-uri-to-recent-manager> {
    tepl_file_add_uri_to_recent_manager($!tf);
  }

  method check_file_on_disk is also<check-file-on-disk> {
    tepl_file_check_file_on_disk($!tf);
  }

  method get_compression_type
    is also<
      get-compression-type
      compression_type
      compression-type
    >
  {
    TeplCompressionTypeEnum( tepl_file_get_compression_type($!tf) );
  }

  method get_encoding (:$raw = False)
    is also<
      get-encoding
      encoding
    >
  {
    my $e = tepl_file_get_encoding($!tf);

    $e ??
      ( $raw ?? $e !! TEPL::Encoding.new($e) )
      !!
      TeplEncoding;
  }

  method get_file_metadata (:$raw = False)
    is also<
      get-file-metadata
      file_metadata
      file-metadata
    >
  {
    my $fm = tepl_file_get_file_metadata($!tf);

    $fm ??
      ( $raw ?? $fm !! TEPL::FileMetadata.new($fm) )
      !!
      TeplFileMetadata;
  }

  method get_location (:$raw = False) is also<get-location> {
    my $f = tepl_file_get_location($!tf);

    $f ??
      ( $raw ?? $f !! GIO::Roles::GFile.new-file-obj($f) )
      !!
      GFile;
  }

  method get_newline_type
    is also<
      get-newline-type
      newline_type
      newline-type
    >
  {
    TeplNewlineTypeEnum( tepl_file_get_newline_type($!tf) );
  }

  method get_short_name
    is also<
      get-short-name
      short_name
      short-name
    >
  {
    tepl_file_get_short_name($!tf);
  }

  method is_deleted is also<is-deleted> {
    so tepl_file_is_deleted($!tf);
  }

  method is_externally_modified is also<is-externally-modified> {
    so tepl_file_is_externally_modified($!tf);
  }

  method is_local is also<is-local> {
    so tepl_file_is_local($!tf);
  }

  method is_readonly is also<is-readonly> {
    so tepl_file_is_readonly($!tf);
  }

  method set_location (GFile() $location) is also<set-location> {
    tepl_file_set_location($!tf, $location);
  }

  method set_mount_operation_factory (
    &callback,
    gpointer $user_data    = Pointer,
    GDestroyNotify $notify = Pointer
  )
    is also<set-mount-operation-factory>
  {
    tepl_file_set_mount_operation_factory(
      $!tf,
      &callback,
      $user_data,
      $notify
    );
  }

}
