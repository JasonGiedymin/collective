#!/bin/bash
#
#
# Knife is brittle. For what reason the important parameters
# are not declarative through the command line, is unknown.
# If they were otherwise, there would be less file moving.
#


#
# Incudes
# =============
#

. /home/vagrant/manifests/init_scripts/lib_functions.sh


#
# Handle Pems
# =============
#

echo "=> Shutting down Chef server to handle Pems"
sudo chef-server-ctl stop

CHEF_SERVER_PEM=/etc/chef-server
LEGACY_CHEF_PEM=/etc/chef

# check if required dirs exist
LOCAL_CHEF_PEM=/home/$CHEF_USER/.chef
if [ ! -d $LOCAL_CHEF_PEM ]; then
  mkdir $LOCAL_CHEF_PEM
fi;

LOCAL_CHEF_REPO=/home/$CHEF_USER/repo
if [ ! -d $LOCAL_CHEF_REPO ]; then
  mkdir $LOCAL_CHEF_REPO
fi;

# Copy pems, knife.rb, and adjust ownership
# sudo cp /etc/chef-server/* /home/vagrant/.chef/
# sudo cp /home/vagrant/manifests/init_scripts/chef/files/chef_pems/knife.rb /home/vagrant/.chef/
# sudo chown vagrant:vagrant /home/vagrant/.chef/*

# Copy to user .chef
sudo cp $CHEF_SERVER_PEM/* $LOCAL_CHEF_PEM/
sudo chown vagrant:vagrant $LOCAL_CHEF_PEM/*

# Copy to default dir
sudo cp $CHEF_SERVER_PEM/* $LEGACY_CHEF_PEM/
sudo chown vagrant:vagrant $LEGACY_CHEF_PEM/*

# Rename for legacy options, maybe these are already cli options?
sudo mv $LEGACY_CHEF_PEM/chef-webui.pem $LEGACY_CHEF_PEM/webui.pem
sudo mv $LEGACY_CHEF_PEM/chef-validator.pem $LEGACY_CHEF_PEM/validation.pem

echo "=> Copied Chef pems."
echo
echo "=> Restarting Chef server..."
sudo chef-server-ctl start

# Sleepy head!
echo "=> Sleeping for 20 seconds for server to catch up"
sleep 20

# Run Knife configure
knife configure -i -s "https://$CHEF_IP" -u "admin" -r "$LOCAL_CHEF_REPO" --defaults -y

# Runs as root, and if we accept defaults dumps knife.rb in root.
# Move it.
mv /root/.chef/knife.rb $LOCAL_CHEF_PEM/
chown vagrant:vagrant $LOCAL_CHEF_PEM/knife.rb

# Wake up!
echo "=> Pinging server with silent curl to wake it up..."
curl -ik https://$CHEF_IP
echo "\n=> Server should be awake!?"

# No seriously, WAKE UP!
echo "=> Sleeping for another 10 seconds for groggy server to wake up..."
sleep 10

echo "Testing knife:"
knife client list

# bootstrap node1
knife bootstrap 10.10.10.12 -x vagrant -P vagrant --sudo
# echo "=> Chef Knife on node: [10.10.10.12]."
