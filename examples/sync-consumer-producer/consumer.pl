#!/usr/bin/env perl

use strict;
use warnings;

use Queue::WithTasks;
use Digest::SHA qw/sha512_hex/;

$|++;

my $qclient = Queue::WithTasks->new( { name => q{workq} });

while (my $task = $qclient->bget_task(1)) {
  print qq{Received producer task ... sending ACK\n}; 
  my $ack = Task->new({ inreplyto => $task->{id}, msg => q{ACK} });
  # set up client to send ack to producer's private queue
  my $qack = Queue::WithTasks->new({ name => $task->{payload}->{replyto} });  
  $qack->submit_task($ack);
}

print qq{Consumer timed out\n};
