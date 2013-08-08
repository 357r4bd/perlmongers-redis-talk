#!/bin/sh

# Usage: ./run-asynchronous <num_producers> <num_consumers>

NUMPROD=${1:-1}
NUMCONS=${2:-4}

# spawn producers
for i in `seq 1 ${NUMPROD}`; do
  (./producer.pl)&
done

# spawn consumers
for i in `seq 1 ${NUMCONS}`; do
  (./consumer.pl)&
done

wait

echo $NUMPROD producers fed work to $NUMCONS consumers
