use v6.c;

use Method::Also;
use NativeCall;

use GTK::Compat::Types;
use TEPL::Raw::Types;

use TEPL::Raw::File;

use GTK::Roles::Properties;

use GIO::Roles::GFile;

use TEPL::Encoding;
use TEPL::FileMetadata;

class TEPL::File {
  also does GTK::Roles::Properties;

  has TeplFile $!tf;

  submethod BUILD (:$file) {
    self!setObject($!tf = $file);                 # GTK::Roles::Properties
  }

  method TEPL::Raw::Types::TeplFile { $!tf }

  multi method new (TeplFile $file) {
    self.bless(:$file);
  }
  multi method new {
    self.bless( file => tepl_file_new() );
  }

  method location is rw {
    Proxy.new:
      FETCH => -> $               { self.get_location      },
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
    TeplCompressionType( tepl_file_get_compression_type($!tf) );
  }

  method get_encoding
    is also<
      get-encoding
      encoding
    >
  {
    TEPL::Encoding.new( tepl_file_get_encoding($!tf) );
  }

  method get_file_metadata
    is also<
      get-file-metadata
      file_metadata
      file-metadata
    >
  {
    TEPL::FileMetadata.new( tepl_file_get_file_metadata($!tf) );
  }

  method get_location is also<get-location> {
    GIO::Roles::GFile.new( tepl_file_get_location($!tf) );
  }

  method get_newline_type
    is also<
      get-newline-type
      newline_type
      newline-type
    >
  {
    TeplNewlineType( tepl_file_get_newline_type($!tf) );
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
