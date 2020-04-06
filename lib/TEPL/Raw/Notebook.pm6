use v6.c;

use NativeCall;

use TEPL::Raw::Types;

unit package TEPL::Raw::Notebook;

sub tepl_notebook_get_type ()
  returns GType
  is native(tepl)
  is export
  { * }

sub tepl_notebook_new ()
  returns TeplNotebook
  is native(tepl)
  is export
  { * }
