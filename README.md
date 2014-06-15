vagrant-hadoop-dev
==================

vagrant config to build a single node hadoop on ubuntu 14

## Instructions

- Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](http://www.vagrantup.com/downloads.html)
- *Linux Users:* Install an NFS daemon, e.g. `apt-get install nfs-kernel-server` 
- Clone this repo
- Run `vagrant up` from the root of the cloned repo.

setup install follow components:
- hadoop 2.4.0
- pig 0.12.1

REMARK: do not use this configuration in production!
