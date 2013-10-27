#!/bin/bash

#
# Init Base
# =============
#
sh /home/vagrant/manifests/init_scripts/base_init.sh


#
# Deploy
# =============
#
sh /home/vagrant/manifests/init_scripts/chef/deploy_chef.sh

#
# Setup
# =============
#
sh /home/vagrant/manifests/init_scripts/chef/setup_chef.sh
