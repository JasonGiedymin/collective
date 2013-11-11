#!/bin/bash

#
# Init Base
# =============
#
bash /home/vagrant/manifests/init_scripts/base_init.sh


#
# Incudes
# =============
#
. /home/vagrant/manifests/init_scripts/lib_functions.sh


# kill any ruby running processes aka chef-zero, until puma is fixed
sudo killall ruby

# Start it in daemon mode
chef-zero -d --host 10.10.10.15 --port 4000

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

echo "Done."