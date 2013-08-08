#!/usr/bin/env perl

use strict;
use warnings;

use Queue::WithTasks;
use Task;
use Digest::SHA qw/sha512_hex/;

$|++;

my $qclient = Queue::WithTasks->new( { name => q{workq} });
my $qlisten  = Queue::WithTasks->new( { name => sha512_hex(rand, rand, rand, $qclient->{redis}->incr(q{producer})) } );

for my $i (1 .. 1000) {
  # add 'replyto' so consumer knows what private queue to submit ACK to
  my $task = Task->new({ life => 42, id => $i, replyto => $qlisten->{name} });
  $qclient->submit_task($task);
  print qq{Submitted $i\n};
  my $ack = $qlisten->bget_task(5);
  if (not $ack) {
    print qq{ACK not received from consumer\n};
    exit;
  }
  print qq{Got ACK from consumer\n};
}
