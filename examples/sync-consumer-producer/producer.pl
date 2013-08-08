#!/usr/bin/env perl

use strict;
use warnings;

use Queue::WithTasks;
use Task;
use Digest::SHA qw/sha512_hex/;

$|++;

my $qclient = Queue::WithTasks->new( { name => q{workq} });

for my $i (1 .. 1000) {
  # create new private queue to listen to for this specific message
  my $qlisten  = Queue::WithTasks->new( { name => sha512_hex(rand, rand, rand, $qclient->{redis}->incr(q{producer})) } );

  # add 'replyto' so consumer knows what private queue to submit ACK to
  my $task = Task->new({ replyto => $qlisten->{name}, fib => [qw/1 1 2 3 5 8 13/], producer_pid => $$ });

  # submit task to consumer
  $qclient->submit_task($task);

  my $id = substr $task->{id}, 0, 10;
  print qq{[Producer $$] Submitted task id $id\n};

  my $ack = $qlisten->bget_task(5);
  if ($ack) {
    my $inreplyto = substr $ack->{payload}->{inreplyto}, 0, 10;
    # verifiy that ACK $inreplyto is the same as expected task $id 
    my $verified = ($task->{id} eq $ack->{payload}->{inreplyto}) ? q{passed} : q{failed};
    print qq{[Producer $$] Got ACK from Consumer $ack->{payload}->{consumer_pid} in reply to task $inreplyto [match: $verified]\n};
  }
  else {
    # shorten task id for reporting
    my $id = substr $task->{id}, 0, 10;
    print qq{[Producer $$] ACK not received from consumer for task id $id :(\n};
  }
  # clean up private queue on Redis server
  $qlisten->delete_queue();
}
