use strict;
use warnings;

use Task;
use Queue::WithTasks;

$|++;

die q{./pingpong.pl [ping | pong]}
  if not $ARGV[0]
      or ( $ARGV[0] ne q{ping} and $ARGV[0] ne q{pong} );

my $pinger = ( $ARGV[0] eq q{ping} ) ? 1 : 0;

my $qclient = Queue::WithTasks->new( { name => q{pingpong} } );

# if $pinger, remove queue and any tasks from incomplete exchange
if ($pinger) {
  $qclient->delete_queue();
}

for ( 1 .. 100 ) {
    if ($pinger) {
        my $ping_task = Task->new( { msg => q{ping} } );
        print qq{Sending Ping..\n};
        $qclient->submit_task($ping_task);
        my $pong = $qclient->bget_task(0);
        if ($pong) {
          print qq{Got Pong!\n};
        }
        else {
          print qq{Timed out waiting for Pong\n};   
          exit;
        }
    }
    else {
        my $ping = $qclient->bget_task(0);
        if ($ping) {
          print qq{Got Ping ... sending Pong\n};
          my $pong_task = Task->new( { msg => q{pong} } );
          $qclient->submit_task($pong_task);
        }
        else {
          print qq{Timed out waiting for Ping\n};
          exit;
        }
    }
}

