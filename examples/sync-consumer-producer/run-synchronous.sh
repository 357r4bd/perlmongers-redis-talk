#!/bin/sh

(./producer.pl)&
(./consumer.pl)&
(./consumer.pl)&
(./consumer.pl)&
(./consumer.pl)&
wait
