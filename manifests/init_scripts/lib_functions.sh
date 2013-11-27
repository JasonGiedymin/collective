#!/bin/bash
#
# lib_functions.sh
#

#
# Guard
# =============
#
# if [ $0 != "-bash" ]; then
#     echo "Do not run this script stand alone!"
#     echo "<= Exiting."
#     exit;
# fi;

export CHEF_USER=vagrant
export CHEF_IP="10.10.10.10"
export KNIFE=/opt/vagrant_ruby/bin/knife
export CHEF_USER_HOME=/home/vagrant

echo
echo "****************************"
echo " Sourced lib_functions Info"
echo "****************************"
echo "Running User=$USER"
echo "CHEF_USER=$CHEF_USER"
echo "CHEF_IP=$CHEF_IP"
echo "****************************"
echo