#!/usr/bin/env perl

use strict;
use warnings;

use Queue::WithTasks;
use Task;

my $qclient = Queue::WithTasks->new( { name => q{workq} });

for my $i (1 .. 1000) {
  my $task = Task->new({ life => 42, id => $i });
  $qclient->submit_task($task);
  print qq{Submitted $i\n};
}
