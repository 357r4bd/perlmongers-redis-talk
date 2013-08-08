#!/usr/bin/env perl

use strict;
use warnings;

use Queue::WithTasks;
use Task;
use Digest::SHA qw/sha512_hex/;

# create client for the WorkQ
my $qclient = Queue::WithTasks->new( { name => q{workq} });

for my $i (1 .. 1000) {
  # generate GUID for task
  my $guid = sha512_hex($i, $$, rand, rand);

  # create Task with arbitrarily complex payload
  my $task = Task->new({ id => $guid, fib => [qw/1 1 2 3 5 8 13/], producer_pid => $$ });

  # submit work, "fire"
  $qclient->submit_task($task);

  # shorten task id for reporting
  my $id = substr $task->{id}, 0, 10;
  print qq{[Producer $$] Submitted task id $id\n};
  # continue (asynchronously) to next task, "forget"
}

print qq{[Producer $$] Finished\n};
