#!/bin/bash


#
# Incudes
# =============
#
. /home/vagrant/manifests/init_scripts/lib_functions.sh


# Copy to ~/.chef/ so to make using knife easier
if [ ! -d $HOME_CHEF_USER ]; then
  mkdir $HOME_CHEF_USER
fi
cp -R /home/vagrant/manifests/chef-server/.chef $HOME_CHEF_USER
chown -R vagrant:vagrant $HOME_CHEF_USER/.chef

echo "=> [.chef] dir copied."