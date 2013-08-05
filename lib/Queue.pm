package Queue;

use strict;
use warnings;
use Data::Dumper ();

use parent q{Redis};
use Exception::Class (
  'X::Fatal',
  'X::CantConnect' => { isa => 'X::Fatal' },
);

sub new  {
  my $pkg = shift;
  my $params = shift;

  my $self = {
      name => $params->{name} || q{myqueue},
  };

  bless $self, $pkg;

  my $ok = eval {
    $self->{redis} = Redis->new( server => q{192.168.3.2:6379} )
      or throw X::CantConnect;
  };

  return $self;
}

sub submit_task {
  my $self = shift;
  my $payload = shift;
  return $self->{redis}->rpush( $self->{name}, $payload );
}

sub bget_task {
  my $self = shift;
  my $timeout = shift // 1;
  my ($list, $payload) = $self->{redis}->blpop( $self->{name}, $timeout );
  return $payload;
}

package main;

my $queue = Queue->new( { name => q{fartbox} });

for my $i (1..10) {
  $queue->submit_task($i);
  my $task = $queue->bget_task(0);
  print qq{$task\n}; 
}

1;
