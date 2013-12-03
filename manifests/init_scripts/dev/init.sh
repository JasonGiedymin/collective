#!/bin/bash

#
# Incudes
# =============
#
. /home/vagrant/manifests/init_scripts/lib_functions.sh


#
# Init Base
# =============
#
bash /home/vagrant/manifests/init_scripts/base_init.sh

bash /home/vagrant/manifests/init_scripts/lib/install_collective.sh
