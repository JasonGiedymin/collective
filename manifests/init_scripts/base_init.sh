#!/bin/bash


#
# Clean the house before the guests arrive...
# =============
#
sudo apt-get update
sudo apt-get install -y language-pack-en
sudo apt-get install -y git vim curl ssh ccache
sudo apt-get install -y g++ gcc ccache python-setuptools python-dev \
libcurl4-openssl-dev libunwind7-dev zookeeper-bin zookeeperd
sudo apt-get install -y screen unzip curl

sudo apt-get autoclean
sudo apt-get autoremove

sudo easy_install httpie

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

#
# Links
# =============
#
MVN=/usr/local/maven-3.1.0/bin/mvn
MVN_BIN=/usr/bin/mvn
if [ -e $MVN_BIN ]; then
  sudo ln -s $MVN $MVN_BIN
fi
