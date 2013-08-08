houston-pm-redis-talk
=====================

My git repo containing example codes and files for talk 8/8/13.

1. install the latest version of VirtualBox and Vagrant

2. git clone this repo from github

  https://github.com/estrabd/houston-pm-redis-talk

3. set up redis VM and client VM

	$ cd houston-pm-redis-talk
	$ vagrant up

4. vagrant ssh producer # main client machine

5. cd /vagrant

	make test
	make examples
