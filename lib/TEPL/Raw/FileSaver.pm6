use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GIO::Raw::Definitions;
use TEPL::Raw::Definitions;

unit package TEPL::Raw::FileSaver;

### /usr/src/tepl/tepl/tepl-file-saver.h

sub tepl_file_saver_error_quark ()
  returns GQuark
  is      native(tepl)
  is      export
{ * }

sub tepl_file_saver_get_buffer (TeplFileSaver $saver)
  returns TeplBuffer
  is      native(tepl)
  is      export
{ * }

sub tepl_file_saver_get_compression_type (TeplFileSaver $saver)
  returns uint32 # TeplCompressionType
  is      native(tepl)
  is      export
{ * }

sub tepl_file_saver_get_encoding (TeplFileSaver $saver)
  returns TeplEncoding
  is      native(tepl)
  is      export
{ * }

sub tepl_file_saver_get_file (TeplFileSaver $saver)
  returns TeplFile
  is      native(tepl)
  is      export
{ * }

sub tepl_file_saver_get_flags (TeplFileSaver $saver)
  returns uint32 # TeplFileSaverFlags
  is      native(tepl)
  is      export
{ * }

sub tepl_file_saver_get_location (TeplFileSaver $saver)
  returns GFile
  is      native(tepl)
  is      export
{ * }

sub tepl_file_saver_get_newline_type (TeplFileSaver $saver)
  returns uint32 # TeplNewlineType
  is      native(tepl)
  is      export
{ * }

sub tepl_file_saver_get_type ()
  returns GType
  is      native(tepl)
  is      export
{ * }

sub tepl_file_saver_new (TeplBuffer $buffer, TeplFile $file)
  returns TeplFileSaver
  is      native(tepl)
  is      export
{ * }

sub tepl_file_saver_new_with_target (
  TeplBuffer $buffer,
  TeplFile   $file,
  GFile      $target_location
)
  returns TeplFileSaver
  is      native(tepl)
  is      export
{ * }

# cw: Needs same treatment as FileLoader.load_async
sub tepl_file_saver_save_async (|c) is export {
  my &saver = do if tepl-version < 5 {

    sub tepl_file_save_save_async (
      TeplFileSaver $saver,
      gint          $io_priority,
      GCancellable  $cancellable,
      Pointer       &progress_callback (goffset, goffset, gpointer), # GFileProgressCallback $progress_callback,
      gpointer      $progress_callback_data,
                    &progress_callback_notify (gpointer),
                    &callback (TeplFileSaver, GAsyncResult, gpointer),
      gpointer      $user_data
    )
      is native(tepl)
    { * }

  } else {

    sub tepl_file_save_save_async (
      TeplFileSaver       $saver,
      gint                $io_priority,
      GCancellable        $cancellable,
                          &callback (TeplFileSaver, GAsyncResult, gpointer),
      gpointer            $user_data
    )
      is native(tepl)
    { * }

  }

  &saver(|c);
}

sub tepl_file_saver_save_finish (
  TeplFileSaver           $saver,
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(tepl)
  is export
{ * }

sub tepl_file_saver_set_compression_type (
  TeplFileSaver $saver,
  uint32        $compression_type # TeplCompressionType $compression_type
)
  is native(tepl)
  is export
{ * }

sub tepl_file_saver_set_encoding (
  TeplFileSaver $saver,
  TeplEncoding  $encoding
)
  is native(tepl)
  is export
{ * }

sub tepl_file_saver_set_flags (
  TeplFileSaver $saver,
  uint32        $flags # sTeplFileSaverFlags $flags
)
  is native(tepl)
  is export
{ * }

sub tepl_file_saver_set_newline_type (
  TeplFileSaver $saver,
  uint32        $newline_type # TeplNewlineType $newline_type
)
  is native(tepl)
  is export
{ * }
