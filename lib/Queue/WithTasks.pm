package Queue::WithTasks;

use strict;
use warnings;

use parent q{Queue};
use Task ();

use Exception::Class (
    'X::Fatal',
    'X::InvalidTask' => { isa => 'X::Fatal' },
);

# assumes Task.pm wrapper

sub _encode {
  my $self = shift;
  my $task = shift;
  eval { $task->isa(q{Task}) }
    or throw X::InvalidTask('Valid Task not provided by caller');
  return $task->_encode_task();
}

sub _decode {
  my $self = shift;
  my $json_task = shift;
  if (not defined $json_task) {
    return $json_task;
  }
  # invalid JSON will cause Task to throw X::InvalidJSON exception
  return Task->_decode_task($json_task);
}

1;
