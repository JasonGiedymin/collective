#!/bin/bash

#
# Incudes
# =============
#
. /home/vagrant/manifests/init_scripts/lib_functions.sh


echo "== Preparing mesos-docker =="
if [ /var/lib/mesos ]; then
  sudo mkdir -p /var/lib/mesos
fi

if [ /var/lib/mesos/executors ]; then
  sudo mkdir -p /var/lib/mesos/executors
fi

echo "== Installing mesos-docker =="
sudo cp -f /home/vagrant/manifests/repos/mesos-docker/bin/mesos-docker /var/lib/mesos/executors/docker

