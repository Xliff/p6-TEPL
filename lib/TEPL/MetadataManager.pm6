use v6.c;

use NativeCall;

use TEPL::Raw::Types;

use GLib::Roles::StaticClass;

class TEPL::MetadataManager {
  also does GLib::Roles::StaticClass;

  method init (Str() $path) {
    tepl_metadata_manager_init($path);
  }

  method shutdown {
    tepl_metadata_manager_shutdown();
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
