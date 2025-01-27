#!perl
# vim:ts=4:sw=4:expandtab
#
# Please read the following documents before working on tests:
# • https://build.i3wm.org/docs/testsuite.html
#   (or docs/testsuite)
#
# • https://build.i3wm.org/docs/lib-i3test.html
#   (alternatively: perldoc ./testcases/lib/i3test.pm)
#
# • https://build.i3wm.org/docs/ipc.html
#   (or docs/ipc)
#
# • https://i3wm.org/downloads/modern_perl_a4.pdf
#   (unless you are already familiar with Perl)
#
# Tests that the border widths can be set separately for floating and
# tiled windows
# Ticket: #1244
# Bug still in: 4.7.2-166-gb69b3fc

use i3test i3_autostart => 0;

#####################################################################
# 1: check that the border widths can be different for floating and
# tiled windows
#####################################################################

my $config = <<EOT;
font -misc-fixed-medium-r-normal--13-120-75-75-C-70-iso10646-1

new_window pixel 5
new_float pixel 10
EOT

my $pid = launch_with_config($config);

my $tmp = fresh_workspace;

ok(@{get_ws_content($tmp)} == 0, 'no containers yet');

my $tilewindow = open_window;
my $floatwindow = open_floating_window;

my $wscontent = get_ws($tmp);

my @tiled = @{$wscontent->{nodes}};
ok(@tiled == 1, 'one tiled container opened');
is($tiled[0]->{current_border_width}, 5, 'tiled current border width set to 5');
is($tilewindow->rect->width, $tiled[0]->{rect}->{width} - 2*5, 'tiled border width 5');

my @floating = @{$wscontent->{floating_nodes}};
ok(@floating == 1, 'one floating container opened');
is($floating[0]->{nodes}[0]->{current_border_width}, 10, 'floating current border width set to 10');
is($floatwindow->rect->width, $floating[0]->{rect}->{width} - 2*10, 'floating border width 10');

exit_gracefully($pid);

#####################################################################
# 2: make sure the order can also be reverse
#####################################################################

$config = <<EOT;
font -misc-fixed-medium-r-normal--13-120-75-75-C-70-iso10646-1

new_float pixel 7
new_window pixel 3
EOT

$pid = launch_with_config($config);

$tmp = fresh_workspace;

ok(@{get_ws_content($tmp)} == 0, 'no containers yet');

$tilewindow = open_window;
$floatwindow = open_floating_window;

$wscontent = get_ws($tmp);

@tiled = @{$wscontent->{nodes}};
ok(@tiled == 1, 'one tiled container opened');
is($tiled[0]->{current_border_width}, 3, 'tiled current border width set to 3');
is($tilewindow->rect->width, $tiled[0]->{rect}->{width} - 2*3, 'tiled border width 3');

@floating = @{$wscontent->{floating_nodes}};
ok(@floating == 1, 'one floating container opened');
is($floating[0]->{nodes}[0]->{current_border_width}, 7, 'floating current border width set to 7');
is($floatwindow->rect->width, $floating[0]->{rect}->{width} - 2*7, 'floating border width 7');

exit_gracefully($pid);

#####################################################################
# 3: make sure normal border widths work as well
#####################################################################

$config = <<EOT;
font -misc-fixed-medium-r-normal--13-120-75-75-C-70-iso10646-1

new_float normal 6
new_window normal 4
EOT

$pid = launch_with_config($config);

$tmp = fresh_workspace;

ok(@{get_ws_content($tmp)} == 0, 'no containers yet');

$tilewindow = open_window;
$floatwindow = open_floating_window;

$wscontent = get_ws($tmp);

@tiled = @{$wscontent->{nodes}};
ok(@tiled == 1, 'one tiled container opened');
is($tiled[0]->{current_border_width}, 4, 'tiled current border width set to 4');
is($tilewindow->rect->width, $tiled[0]->{rect}->{width} - 2*4, 'tiled border width 4');

@floating = @{$wscontent->{floating_nodes}};
ok(@floating == 1, 'one floating container opened');
is($floating[0]->{nodes}[0]->{current_border_width}, 6, 'floating current border width set to 6');
is($floatwindow->rect->width, $floating[0]->{rect}->{width} - 2*6, 'floating border width 6');

exit_gracefully($pid);

done_testing;
