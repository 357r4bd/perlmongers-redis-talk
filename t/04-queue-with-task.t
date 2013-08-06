use strict;
use warnings;

use Test::More;
use Data::Dumper ();

use_ok q{Queue::WithTasks};
use_ok q{Task};

my $queue = new_ok q{Queue::WithTasks} => [{ name => q{fartbox}}];

# flush queue
for my $i ( 1 .. 10 ) {
    my $task = $queue->get_task(0);
}
# get in receive, in order
for my $i ( 1 .. 10 ) {
    my $task = Task->new({ msg => $i });
    $queue->submit_task($task);
    my $new_task = $queue->bget_task(0);
    is_deeply $task, $new_task, q{bget new task matches submitted task}; 
}

done_testing;
