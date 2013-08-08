#!/bin/env perl

use strict;
use warnings;

use Queue::WithTasks;

my $qclient = Queue::WithTasks->new( { name => q{workq} });
while (my $task = $qclient->bget_task(30)) {
  print $task->_encode_task(), qq{\n}; 
}

print qq{Consumer timed out\n};
