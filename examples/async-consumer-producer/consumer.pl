#!/usr/bin/env perl

use strict;
use warnings;

use Queue::WithTasks;

# crate client for WorkQ, wait for work
my $qclient = Queue::WithTasks->new( { name => q{workq} });

# wait for work, breaks while condition on time out
while (my $task = $qclient->bget_task(1)) {
  # do something with task  
  # shorten $id just for reporting
  my $id = substr $task->{id}, 0, 10;
  print qq{[Consumer $$] Processed $task->{type} from Producer $task->{payload}->{producer_pid} with id $id\n};
}

# final message
print qq{[Consumer $$] Consumer tired of waiting for more work\n};
