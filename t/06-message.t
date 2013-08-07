use strict;
use warnings;

use Test::More;
use Test::Exception;

use_ok q{Message};

my $message = new_ok q{Message} => [ { msg => q{hello, world} } ], q{create new task with payload};

my $encoded = q{};

throws_ok {my $encoded = $message->_encode_task()} q{X::MissingHeader}, q{catch X::MissingHeader 'to' on encode};

$message->{to} = 'f00';

throws_ok {my $encoded = $message->_encode_task()} q{X::MissingHeader}, q{catch X::MissingHeader 'from' on encode};

$message->{from} = 'bar';

lives_ok {$encoded = $message->_encode_task()} q{message encoding doesn't throw exception}; 

ok my $new_message = Message->_decode_task($encoded), q{create new Message from JSON encoding of a task}; 

is_deeply $message, $new_message, q{task and new_message match deeply};

ok my $new_encoded = $new_message->_encode_task(), q{encode newly decoded task};

is $encoded, $new_encoded, q{encoded, decoded, encoded match};

done_testing;
