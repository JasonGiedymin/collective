#!/bin/bash

echo "**********************************"
echo "*****     INIT RUNNING       *****"
echo "**********************************"

#
# Init Base
# =============
#

sh /home/vagrant/manifests/init_scripts/base_init.sh


#
# Deploy
# =============
# Note: this script is now deprecated but left for posperity
#       install is now done via chef-server cookbook
# sh /home/vagrant/manifests/init_scripts/chef/deploy_chef.sh


#
# Setup
# =============
# Note: This is still applicable, as it sets up knife

sh /home/vagrant/manifests/init_scripts/chef/setup_chef.sh


#
# Knife Configure
# =============
#

sh /home/vagrant/manifests/init_scripts/chef/manage_chef.sh

