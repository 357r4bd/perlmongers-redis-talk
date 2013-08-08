#!/usr/bin/env perl

use strict;
use warnings;

use Queue::WithTasks;
use Digest::SHA qw/sha512_hex/;

$|++;

my $qclient = Queue::WithTasks->new( { name => q{workq} });

while (my $task = $qclient->bget_task(1)) {
  print qq{[Consumer $$] Received task from Producer $task->{payload}->{producer_pid} ... sending ACK\n}; 

  # set inreply to so Producer can verify that this is the task reply it's waiting for
  my $ack = Task->new({ inreplyto => $task->{id}, msg => q{ACK}, consumer_pid => $$ });

  # set up client to send ack to producer's private queue
  my $qack = Queue::WithTasks->new({ name => $task->{payload}->{replyto} });  
  $qack->submit_task($ack);
  my $to = substr $qack->{name}, 0, 10;
  print qq{[Consumer $$] Sent ACK to $to\n};
}

# final message
print qq{[Consumer $$] Consumer tired of waiting for more work\n};
