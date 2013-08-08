use strict;
use warnings;

use Task::Ping;
use Task::Pong;
use Queue::WithTasks;

# autoflush to stdout
$|++;

# mode required, is it the pinger or ponger?
die q{./pingpong.pl [ping | pong]}
  if not $ARGV[0]
      or ( $ARGV[0] ne q{ping} and $ARGV[0] ne q{pong} );

# set convenient variable for checking mode
my $pinger = ( $ARGV[0] eq q{ping} ) ? 1 : 0;

# number of rounds
my $rounds = ( int $ARGV[1] > 0 ) ? int $ARGV[1] : 1;

# set target queue to submit task 
my $send_q = Queue::WithTasks->new( { name => ($pinger) ? q{pong} : q{ping} } );

# set queue to "listen"; pinger waits for Pong, pinger waits for next Ping
my $receive_q = Queue::WithTasks->new( { name => ($pinger) ? q{ping} : q{pong} } );

for ( my $i = 1; $i <= $rounds; $i++ ) {
    # block for ping mode - send Ping, wait for Pong
    if ($pinger) { # test for time out
        # create new Ping task
        my $ping_task = Task::Ping->new( { msg => q{ping}, i => $i } );
        print qq{Sending $ping_task->{type} $i ...\n};
        # send Ping to awaiting Ponger
        $send_q->submit_task($ping_task);
        # wait for Pong reply
        my $pong = $receive_q->bget_task(0);
        if ($pong) {
          my $json = $pong->_encode_task;
          print qq{Got $pong->{type} $i\n};
        }
        else {
          print qq{Timed out waiting for Pong $i\n};   
        }
    }
    # block for pong mode - wait for Ping, reply with Pong
    else {
        # wait for Pong
        my $ping = $receive_q->bget_task(1); # timeout of 1 second is sufficient for this example
        if ($ping) { # test for time out
          my $json = $ping->_encode_task;
          # create Pong for response
          my $pong_task = Task::Pong->new( { msg => q{pong}, i => $i } );
          print qq{Got $ping->{type} $i ... sending $pong_task->{type} $i\n};
          # send Pong to Pinger
          $send_q->submit_task($pong_task);
        }
        else {
          print qq{Timed out waiting for Ping $i\n};
        }
    }
}

# clean up one's receiver queue
$receive_q->delete_queue();
