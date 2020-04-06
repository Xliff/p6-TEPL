use v6.c;

use NativeCall;
use Method::Also;

use TEPL::Raw::Definitions;

use GLib::Roles::StaticClass;

class TEPL::Main {
  also does GLib::Roles::StaticClass;

  method init {
    tepl_init();
  }

  method quit is also<finalize end> {
    tepl_finalize();
  }

}

sub tepl_init()
  is native(tepl)
  is export
  { * }

sub tepl_finalize()
  is native(tepl)
  is export
  { * }
