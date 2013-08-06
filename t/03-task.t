use strict;
use warnings;

use Test::More;
use Data::Dumper ();

use_ok q{Task};

my $task = new_ok q{Task} => [ { msg => q{hello, world} } ], q{create new task with payload};

ok my $encoded = $task->_encode_task(), q{encode task to JSON};

ok my $new_task = Task->_decode_task($encoded), q{create new Task from JSON encoding of a task}; 

is_deeply $task, $new_task, q{task and new_task match deeply};

ok my $new_encoded = $new_task->_encode_task(), q{encode newly decoded task};

is $encoded, $new_encoded, q{encoded, decoded, encoded match};

done_testing;
