use v6.c

use GTK::Application;
use GTK::Box;
use GTK::Button;
use GTK::TextBuffer;
use GTK::TextIter;

use GTK::ScrolledWindow;
use TEPL::FoldRegion;
use TEPL::View;

my $fold_region;

sub create_view {
  my $view = TEPL::View.new;
  (my $b = $view.buffer).text = ('Line' «~» ^6).join("\n");
  my ($start, $end) = (1, 3).map({ $view.buffer.get_iter_at_line($_) });
  ($fold_region = TEPL::FoldRegion.new($b, $start, $end)).folded = True;

  $view;
}

sub MAIN {
  my $app = GTK::Application.new( title => 'org.genex.tepl.folded_region' );

  $app.activate.tap({
    $app.wait_for_init;

    my $sw = GTK::ScrolledWindow.new;
    $sw.add(create_view);

    my $box = GTK::Box.new-vbox;
    $box.pack_start($sw, True, True);

    my $button = GTK::Button.new_with_label('Toggle Region');
    $button.clicked.tap({ $fold_region.folded .= not });
    $box.add($button);

    $app.window.set_default_size(500, 500);
    $app.window.add($box);
    $app.window.show_all;
  });

  $app.run;
}
