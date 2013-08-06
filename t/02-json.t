use strict;
use warnings;
use lib q{../lib};
use Queue::JSON;
use Test::More;
use Data::Dumper ();


my $queue = new_ok q{Queue::JSON} => [{ name => q{fartbox}}];

# flush queue
for my $i ( 1 .. 10 ) {
    my $task = $queue->get_task(0);
}
# get in receive, in order
for my $i ( 1 .. 10 ) {
    my $task_ref = { id => $i };
    $queue->submit_task($task_ref);
    my $task = $queue->bget_task(0);
    my $id = $task->{id};
    ok $id == $i, qq{Got task ( $id == $i ) okay}; 
}

done_testing;
