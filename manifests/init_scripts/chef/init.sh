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



#
# Info
# =============
#
echo "=> Ruby version"
ruby -v

echo "=> ENV:"
env

echo "=> Current user is: [$USER] "

echo "=> Gem list:"
gem list



# kill any ruby running processes aka chef-zero, until puma is fixed
sudo killall ruby

# Start it in daemon mode
chef-zero -d --host 10.10.10.10 --port 4000

# Upload cookbooks
cd /home/vagrant/manifests/chef-server

# Run client list to test
knife client -V list

# berks upload -c ./berks-config.json
# sudo knife upload -V --force cookbooks
# sudo knife upload -V --force roles

knife cookbook list

# knife configure \
#   -r /home/vagrant/manifests/berkshelf/cookbooks \
#   -i -s https://10.10.10.10 \
#   -u admin \
#   -r /home/vagrant/.chef/ \
#   --defaults -y


#
# Run docker-registry
# =============
#
bash /home/vagrant/manifests/init_scripts/lib/run_docker_registry.sh

echo "Chef server up and running. Actions complete."
echo