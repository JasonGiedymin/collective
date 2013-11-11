#!/bin/bash


#
# Clean the house before the guests arrive...
# =============
#
sudo apt-get update
sudo apt-get install -y language-pack-en
sudo apt-get install -y git vim curl ssh
sudo apt-get autoclean
sudo apt-get autoremove
echo "=> Completed system update and cleanup."

#
# Modify SSHd
# =============
#
sudo bash /home/vagrant/manifests/init_scripts/modify_sshd_config.sh


#
# Modify RCs
# =============
#
echo "gem: --no-rdoc --no-ri" > ~/.gemrc


#
# Prep for chef
# =============
#
sudo bash /home/vagrant/manifests/init_scripts/chef_prep.sh