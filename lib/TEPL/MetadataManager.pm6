use v6.c;

use NativeCall;

use GTK::Compat::Types;
use TEPL::Raw::Types;

class TEPL::MetadataManager {

  method init (Str() $path) {
    tepl_metadata_manager_init($path);
  }

  method shutdown {
    tepl_metadata_manager_shutdown();
  }

  method new {
    warn 'TEPL::MetadataManager is a static class and cannot be instantiated!';
    TEPL::MetadataManager;
  }

}

sub tepl_metadata_manager_init (Str $metadata_path)
  is native(tepl)
  is export
{ * }

sub tepl_metadata_manager_shutdown ()
  is native(tepl)
  is export
{ * }
