#!/bin/bash


#
# Incudes
# =============
#
. /home/vagrant/manifests/init_scripts/lib_functions.sh


# Copy to ~/.chef/ so to make using knife easier
if [ ! -d $CHEF_USER_HOME ]; then
  mkdir $CHEF_USER_HOME
fi
cp -R /home/vagrant/manifests/chef-server/.chef $CHEF_USER_HOME
chown -R vagrant:vagrant $CHEF_USER_HOME/.chef

echo "=> [.chef] dir copied."