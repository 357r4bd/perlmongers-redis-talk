use strict;
use warnings;
use lib q{../lib};
use Queue;
use Test::More;


my $queue = new_ok q{Queue} => [{ name => q{fartbox}}];

# flush queue
for my $i ( 1 .. 10 ) {
    my $task = $queue->get_task(0);
}
# get in receive, in order
for my $i ( 1 .. 10 ) {
    $queue->submit_task($i);
    my $task = $queue->bget_task(0);
    ok $i, qq{Got task ( $task == $i ) okay}; 
}

done_testing;
