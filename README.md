vagrant-hadoop-dev
==================

vagrant config to build a single node hadoop on ubuntu 14

## Instructions

- Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](http://www.vagrantup.com/downloads.html)
- *Linux Users:* Install an NFS daemon, e.g. `apt-get install nfs-kernel-server` 
- Clone this repo
- Run `vagrant up` from the root of the cloned repo.
- Connect to hadoop machine running `vagrant ssh`
- Start hadoop running both `start-dfs.sh`
- Verify installation typing `jps`: check if namenode, datanode and secondary name node are present
- Open your host machine browser and go to hadoop installation [website](http://10.17.3.10:50070). If you need, you can browse hdfs [filesystem](http://10.17.3.10:50070/explorer.html#/)

setup install follow components:
- java 7
- hadoop 2.4.0

## Run sample map reduce

- Go to hadoop dir: `cd /usr/local/hadoop`
- Create hdfs input folder: `bin/hdfs dfs -mkdir -p /user/vagrant/input`
- Put some sample files to input hdfs folder: bin/hdfs dfs -put etc/hadoop/* input`
- Run mapreduce counting all occurences of string 'dfs': `bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.4.0.jar grep input output 'dfs[a-z.]+'`
- Show results: bin/hdfs dfs -cat output/*

## Some notes

- You can read hdfs commands docs [here](http://hadoop.apache.org/docs/r2.4.0/hadoop-project-dist/hadoop-common/FileSystemShell.html)
- For list of all example map reduce builtin in default hadoop package, type: `bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-2.4.0.jar`

*do not use this in production environment!*
