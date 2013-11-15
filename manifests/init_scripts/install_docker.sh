#!/bin/bash

#
# Init Base
# =============
#
bash /home/vagrant/manifests/init_scripts/base_init.sh


#
# Incudes
# =============
#
. /home/vagrant/manifests/init_scripts/lib_functions.sh


#
# Setup Docker
# =============
#
# sudo apt-get install -y linux-image-generic-lts-raring linux-headers-generic-lts-raring