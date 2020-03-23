use v6.c;

use Method::Also;
use NativeCall;

use GTK::Compat::Types;
use GTK::Raw::Utils;
use TEPL::Raw::Types;
use TEPL::Raw::FileLoader;

use GLib::Value;

use GTK::Roles::Properties;

class TEPL::FileLoader {
  also does GTK::Roles::Properties;

  has TeplFileLoader $!fl;

  method BUILD (:$loader) {
    self.setObject($!fl = $loader);
  }

  method TEPL::Raw::Types::TeplFileLoader
    is also<
      TeplFileLoader
      FileLoader
    >
  { $!fl }

  multi method new (TeplFileLoadfer $loader) {
    self.bless( :$loader );
  }
  multi method new (TeplBuffer $buffer, TeplFile $file) {
    self.bless( loader => tepl_file_loader_new($buffer, $file) );
  }

  # Type: gint64
  method chunk-size is rw  {
    my GLib::Value $gv .= new( G_TYPE_INT64 );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('chunk-size', $gv)
        );
        $gv.int64;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int64 = $val;
        self.prop_set('chunk-size', $gv);
      }
    );
  }

  # Type: gint64
  method max-size is rw  {
    my GLib::Value $gv .= new( G_TYPE_INT64 );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('max-size', $gv)
        );
        $gv.int64;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int64 = $val;
        self.prop_set('max-size', $gv);
      }
    );
  }

  method error_quark is also<error-quark> {
    tepl_file_loader_error_quark();
  }

  method get_buffer
    is also<
      get-buffer
      buffer
    >
  {
    tepl_file_loader_get_buffer($!fl);
  }

  method get_encoding
    is also<
      get-encoding
      encoding
    >
  {
    tepl_file_loader_get_encoding($!fl);
  }

  method get_file
    is also<
      get-file
      file
    >
  {
    tepl_file_loader_get_file($!fl);
  }

  method get_location
    is also<
      get-location
      location
    >
  {
    tepl_file_loader_get_location($!fl);
  }

  method get_newline_type
    is also<
      get-newline-type
      newline_type
      newline-type
    >
  {
    TeplNewlineType( tepl_file_loader_get_newline_type($!fl) );
  }

  proto method load_async (|)
    is also<load-async>
  { * }

  multi method load_async (
    Int() $io_priority,
    &callback,
    &progress_callback                       = -> *@a { },
    gpointer $user_data                      = Pointer,
    gpointer $progress_callback_data         = Pointer,
    GCancellable() $cancellable              = GCancellable,
    GDestroyNotify $progress_callback_notify = Pointer
  ) {
    samewith(
      $io_priority,
      $cancellable,
      &progress_callback,
      $progress_callback_data,
      $progress_callback_notify,
      &callback,
      $user_data
    );
  }
  multi method load_async (
    Int() $io_priority,
    GCancellable() $cancellable,
    &progress_callback,
    gpointer $progress_callback_data,
    GDestroyNotify $progress_callback_notify,
    &callback,
    gpointer $user_data
  ) {
    my guint $io = resolve-int($io_priority);
    tepl_file_loader_load_async(
      $!fl,
      $io,
      $cancellable,
      &progress_callback,
      $progress_callback_data,
      $progress_callback_notify,
      &callback,
      $user_data
    );
  }

  method load_finish (
    GAsyncResult() $result,
    CArray[Pointer[GError]] $error = gerror()
  )
    is also<load-finish>
  {
    clear_error;
    my $rc = tepl_file_loader_load_finish($!fl, $result, $error);
    set_error($error);
    $rc;
  }


}
