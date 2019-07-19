use v6.c;

use Method::Also;

use TEPL::Raw::Types;

use NativeCall;

class TEPL::Main {
  
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
