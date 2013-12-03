#!/bin/bash

#
# Incudes
# =============
#
. /home/vagrant/manifests/init_scripts/lib_functions.sh

serviceAction zookeeper stop
serviceAction mesos-master stop
serviceAction mesos-slave stop
serviceAction marathon stop

# Install Mesos
bash manifests/init_scripts/lib/install_mesos.sh

# # Install Marathon
bash manifests/init_scripts/lib/install_marathon.sh

# # Install Mesos-docker-executor
bash manifests/init_scripts/lib/install_mesos_docker.sh

serviceAction zookeeper restart
serviceAction mesos-master restart
serviceAction mesos-slave restart
serviceAction marathon restart
