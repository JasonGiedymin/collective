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

function link() {
  local src=/home/vagrant/manifests/repos/mesos-docker/bin/mesos-docker
  local dest=/var/lib/mesos/executors/docker

  if [ ! -e $dest ]; then
    echo "== Installing mesos-docker... =="
    sudo cp -f $src $dest
  else
    echo "== Mesos-docker already installed, skipping... =="
  fi
}

link