#!/bin/sh

ROUNDS=${1:-1000}

(perl ./pingpong.pl ping $ROUNDS)&
(perl ./pingpong.pl pong $ROUNDS)&
wait
