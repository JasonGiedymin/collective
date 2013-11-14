#!/bin/bash

echo "**********************************"
echo "*****     INIT RUNNING       *****"
echo "**********************************"

#
# Init Base
# =============
#

bash /home/vagrant/manifests/init_scripts/base_init.sh


#
# Info
# =============
#
echo "=> ENV:"
env
echo "=> Current user is: [$USER] "
echo "=> Gem list:"
gem list


#
# Deploy
# =============
# Note: this script is now deprecated but left for posperity
#       install is now done via chef-server cookbook

bash /home/vagrant/manifests/init_scripts/chef/deploy_chef.sh


#
# Setup
# =============
# Note: This is still applicable, as it sets up knife

bash /home/vagrant/manifests/init_scripts/chef/setup_chef.sh


#
# Knife Configure
# =============
#

bash /home/vagrant/manifests/init_scripts/chef/manage_chef.sh

