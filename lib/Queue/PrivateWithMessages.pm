package Queue::PrivateWithMessages;

use strict;
use warnings;
use Digest::SHA qw/sha512_hex/;

use parent q{Queue};
use Message ();

use Exception::Class (
    'X::Fatal',
    'X::InvalidMessage' => { isa => 'X::Fatal' },
);

sub new {
    my $pkg    = shift;
    my $params = shift;

    my $self = {};
    bless $self, $pkg;

    $self->_connect;

    # generate globally unique queue name 
    $self->{name} = sha512_hex($pkg, rand, $self->{redis}->incr($pkg));

    return $self;
}

# assumes Message.pm wrapper

sub _encode {
  my $self = shift;
  my $task = shift;
  eval { $task->isa(q{Message}) }
    or throw X::InvalidMessage('Valid Message not provided by caller');
  return $task->_encode_task();
}

sub _decode {
  my $self = shift;
  my $json_task = shift;
  if (not defined $json_task) {
    return $json_task;
  }
  # invalid JSON will cause Message to throw X::InvalidJSON exception
  return Message->_decode_task($json_task);
}

sub send_message {
  my $self = shift;
  my $message = shift;
  # set $message->{from} with $self->{name}, which is a "private" queue
  $message->{from} = $self->{name};
  return $self->submit_task(@_);	
}

sub wait_for_message {
  my $self = shift;
  return $self->bget_task(@_);
}

1;
