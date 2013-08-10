houston-pm-redis-talk
=====================

My git repo containing example codes and files for talk 8/8/13.

0.a  talk via Google Docs - 
	https://docs.google.com/presentation/d/1bfEOFUbnl8Ea9eObyIITXjqdwcwPvx-S7uNPklYu-ug/edit?usp=sharing
	
0.b  screencast of actual talk, https://vimeo.com/72078698

1. install the latest version of VirtualBox and Vagrant

2. git clone this repo from github

	$ git clone https://github.com/estrabd/houston-pm-redis-talk

	(or download from https://github.com/estrabd/houston-pm-redis-talk/archive/master.zip)

3. set up redis VM and client VM

	$ cd houston-pm-redis-talk

	$ vagrant up

4. ssh into "producer" VM:

	$ vagrant ssh producer # main client machine

5. try it out!

	$ cd /vagrant

	$ make test

	$ make examples
