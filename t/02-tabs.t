use v6.c;

use lib <t .>;

use GTK::Compat::Types;
use GTK::Raw::Types;
use SourceViewGTK::Raw::Types;

use GIO::Raw::Quarks;
use SourceViewGTK::Raw::Quarks;

use GTK::Application;
use GTK::Button;
use GTK::Entry;
use GTK::Grid;

use SourceViewGTK::File;
use SourceViewGTK::FileLoader;

use TEPL::InfoBar;
use TEPL::Tab;

use ProgressInfoBar;

sub add-loading-error-info-bar ($t, $e) {
  ( my $file = SourceViewGTK::File.new ).location =
    GIO::Roles::GFile.new_for_path("/home/seb/test.c");;

  my $buffer = SourceViewGTK::Buffer.new;
  my $loader = SourceViewGTK::FileLoader.new($buffer, $file);

  my $info-bar = TEPL::ErrorInfoBar.new;
  $info-bar.response.tap({ $info-bar.destroy });

  $info-bar.set-loading-error($loader, $e);
  $t.add-info-bar($info-bar);
  $info-bar.show;
}

sub create-side-panel ($t) {
  my $vgrid = GTK::Grid.new-vgrid(6);

  my $basic = GTK::Button.new-with-label('Basic');
  $basic.clicked.tap({
    my $info-bar = TEPL::InfoBar.new_simple(
      GTK_MESSAGE_WARNING,
      'Primary Message',
      'Secondary Message'
    );

    my $entry = GTK::Entry.new;
    $info-bar.add_content_widget($entry);
    $info-bar.add_close_button;
    .show for $entry, $info-bar;
    $t.add-info-bar($info-bar.ref);
  });

  my $progress = GTK::Button.new-with-label('Progress');
  $progress.clicked.tap({
    my $lt = qq:to/TEXT/.chomp;
      File loading... The full and very long path is:
      /home/seb/a/very/long/path/like/this/is/beautiful{ ''
      }/but/is/it/correctly/wrapped/in/the/info/bar/that{ ''
      }/is/the/question
      TEXT

    my $info-bar = TEPL::ProgressInfoBar.new($lt, True);
    $info-bar.fraction = 0.3;
    $info-bar.response.tap(-> *@a { $info-bar.destroy });

    $t.add-info-bar($info-bar);
    $info-bar.show;
  });

  my $permission-denied = GTK::Button.new-with-label('Permission Denied');
  $permission-denied.clicked.tap({
    my $e = GError.new($G_IO_ERROR, G_IO_ERROR_PERMISSION_DENIED, 'blah');
    add-loading-error-info-bar($t, $e);
  });

  my $not-found = GTK::Button.new-with-label('Not found');
  $not-found.clicked.tap({
    my $e = GError.new($G_IO_ERROR, G_IO_ERROR_NOT_FOUND, 'blah');
    add-loading-error-info-bar($t, $e);
  });

  my $conversion-fallback = GTK::Button.new-with-label('Conversion Fallback');
  $conversion-fallback.clicked.tap({
    my $e = GError.new(
      $GTK_SOURCE_FILE_LOADER_ERROR,
      GTK_SOURCE_FILE_LOADER_ERROR_CONVERSION_FALLBACK,
      'blah'
    );
    add-loading-error-info-bar($t, $e);
  });

  $vgrid.add($_) for $basic, $progress, $permission-denied, $not-found,
                     $conversion-fallback;

  $vgrid;
}

sub MAIN {
  my $a = GTK::Application.new(
    title  => 'org.genex.TeplTabs-test',
    width  => 800,
    height => 600
  );

  $a.activate.tap({
    $a.wait-for-init;

    my $tab = TEPL::Tab.new;
    my $hgrid = GTK::Grid.new-hgrid(6);

    $hgrid.margins = 6;
    $hgrid.add( create-side-panel($tab) );
    $hgrid.add($tab);
    $hgrid.show-all;

    $a.window.add($hgrid);
    $a.window.show;
  });

  $a.run;
}
