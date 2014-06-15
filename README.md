vagrant-hadoop-dev
==================

vagrant config to build a single node hadoop on ubuntu 14

## Instructions

- Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](http://www.vagrantup.com/downloads.html)
- *Linux Users:* Install an NFS daemon, e.g. `apt-get install nfs-kernel-server` 
- Clone this repo
- Run `vagrant up` from the root of the cloned repo.
- Connect to hadoop machine running `vagrant shh`
- Start hadoop running both `start-dfs.sh` and `start-yarn-sh`
- Verify installation typing `jps`

setup install follow components:
- hadoop 2.4.0
- pig 0.12.1

*do not use this in production environment!*

For full details see tutorial [How to Install Hadoop on Ubuntu 13.10](https://www.digitalocean.com/community/tutorials/how-to-install-hadoop-on-ubuntu-13-10)
