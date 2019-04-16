use v6.c;

use GTK::Compat::Types;
use TEPL::Raw::Types;

use GTK::Compat::Roles::Properties;

use GTK::Compat::File;

use TEPL::Encoding;
use TEPL::FileMetadata;

class TEPL::File {
  also does GTK::Compat::Roles::Object;

  has TeplFile $!tf;

  submethod BUILD (:$file) {
    self!setObject($!tf = $file);                 # GTK::Roles::Object
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

  method add_uri_to_recent_manager  {
    tepl_file_add_uri_to_recent_manager($!tf);
  }

  method check_file_on_disk {
    tepl_file_check_file_on_disk($!tf);
  }

  method get_compression_type {
    TeplCompressionType( tepl_file_get_compression_type($!tf) );
  }

  method get_encoding {
    TEPL::Encoding.new( tepl_file_get_encoding($!tf) );
  }

  method get_file_metadata {
    TEPL::FileMetadata.new( tepl_file_get_file_metadata($!tf) );
  }

  method get_location {
    GTK::Compat::File.new( tepl_file_get_location($!tf) );
  }

  method get_newline_type {
    TeplNewlineType( tepl_file_get_newline_type($!tf) );
  }

  method get_short_name {
    tepl_file_get_short_name($!tf);
  }

  method is_deleted {
    so tepl_file_is_deleted($!tf);
  }

  method is_externally_modified {
    so tepl_file_is_externally_modified($!tf);
  }

  method is_local {
    so tepl_file_is_local($!tf);
  }

  method is_readonly {
    so tepl_file_is_readonly($!tf);
  }

  method set_location (GFile() $location) {
    tepl_file_set_location($!tf, $location);
  }

  method set_mount_operation_factory (
    &callback,
    gpointer $user_data    = Pointer,
    GDestroyNotify $notify = Pointer
  ) {
    tepl_file_set_mount_operation_factory(
      $!tf,
      $callback,
      $user_data,
      $notify
    );
  }

}
