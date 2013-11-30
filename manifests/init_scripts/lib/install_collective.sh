#!/bin/bash

#
# Incudes
# =============
#
. /home/vagrant/manifests/init_scripts/lib_functions.sh

# Install Mesos
bash manifests/init_scripts/lib/install_mesos.sh

# # Install Marathon
bash manifests/init_scripts/lib/install_marathon.sh

# # Install Mesos-docker-executor
bash manifests/init_scripts/lib/install_mesos_docker.sh

serviceRestart zookeeper
serviceRestart mesos-master
serviceRestart mesos-slave
serviceRestart marathon
