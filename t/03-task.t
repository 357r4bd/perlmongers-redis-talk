use strict;
use warnings;

use Test::More;
use Test::Exception;

use_ok q{Task};

my $task = new_ok q{Task} => [ { msg => q{hello, world} } ], q{create new task with payload};

ok my $encoded = $task->_encode_task(), q{encode task to JSON};

ok my $new_task = Task->_decode_task($encoded), q{create new Task from JSON encoding of a task}; 

is_deeply $task, $new_task, q{task and new_task match deeply};

ok my $new_encoded = $new_task->_encode_task(), q{encode newly decoded task};

is $encoded, $new_encoded, q{encoded, decoded, encoded match};

throws_ok { my $task = Task->new() } q{X::MissingPayload}, q{catch exception with empty payload};

throws_ok { my $task = Task->new(q{foo}) } q{X::MissingPayload}, q{catch exception with simple scalar payload};

throws_ok { my $task = Task->new([q{foo}, q{bar}]) } q{X::MissingPayload}, q{catch exception with simple array ref payload};

throws_ok { my $task = Task->new([q{foo}, q{bar}]) } q{X::MissingPayload}, q{catch exception with simple array ref payload};

my @foo = (q{foo}, q{bar}, q{baz});
throws_ok { my $task = Task->new(@foo) } q{X::MissingPayload}, q{catch exception with simple array payload};

lives_ok { my $task = Task->new({foo => q{bar}}) } q{expected hash ref sent as payload};

my %foo = ( foo => q{bar} );
lives_ok { my $task = Task->new(\%foo) } q{expected hash ref sent as payload};

throws_ok { my $task = Task->new(%foo) } q{X::MissingPayload}, q{catch exception with actual hash as payload};


done_testing;
