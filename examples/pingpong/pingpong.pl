use strict;
use warnings;

use Task::Ping;
use Task::Pong;
use Queue::WithTasks;

$|++;

die q{./pingpong.pl [ping | pong]}
  if not $ARGV[0]
      or ( $ARGV[0] ne q{ping} and $ARGV[0] ne q{pong} );

my $pinger = ( $ARGV[0] eq q{ping} ) ? 1 : 0;

my $receive_q = Queue::WithTasks->new( { name => ($pinger) ? q{ping} : q{pong} } );
my $send_q = Queue::WithTasks->new( { name => ($pinger) ? q{pong} : q{ping} } );

## send to appropriate queue!

# if $pinger, remove queue and any tasks from incomplete exchange
if ($pinger) {
  $receive_q->delete_queue();
}

for ( my $i = 1; $i <= 1000; $i++ ) {
    if ($pinger) {
        my $ping_task = Task::Ping->new( { msg => q{ping}, i => $i } );
        print qq{Sending $ping_task->{type} $i ...\n};
        $send_q->submit_task($ping_task);
        my $pong = $receive_q->bget_task(0);
        if ($pong) {
          my $json = $pong->_encode_task;
          print qq{Got $pong->{type} $i\n};
        }
        else {
          print qq{Timed out waiting for Pong $i\n};   
        }
    }
    else {
        my $ping = $receive_q->bget_task(1);
        if ($ping) {
          my $json = $ping->_encode_task;
          my $pong_task = Task::Pong->new( { msg => q{pong}, i => $i } );
          print qq{Got $ping->{type} $i ... sending $pong_task->{type} $i\n};
          $send_q->submit_task($pong_task);
        }
        else {
          print qq{Timed out waiting for Ping $i\n};
        }
    }
}

# if not $pinger, remove queue and any tasks from incomplete exchange
if (not $pinger) {
  $receive_q->delete_queue();
}
