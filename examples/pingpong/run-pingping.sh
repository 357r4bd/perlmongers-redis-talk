#!/bin/sh

(perl ./pingpong.pl ping)&
(perl ./pingpong.pl pong)&
wait
