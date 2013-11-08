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

CHEF_SERVER_PEM=/etc/chef-server
LEGACY_CHEF_PEM=/etc/chef
LOCAL_CHEF_PEM=/home/$CHEF_USER/.chef
LOCAL_CHEF_REPO=/home/$CHEF_USER/manifests/repos/collective-cookbooks

# Copy pems, knife.rb, and adjust ownership
# sudo cp /etc/chef-server/* /home/vagrant/.chef/
# sudo cp /home/vagrant/manifests/init_scripts/chef/files/chef_pems/knife.rb /home/vagrant/.chef/
# sudo chown vagrant:vagrant /home/vagrant/.chef/*

prepareChef() {
  echo "=> Shutting down Chef server to handle Pems"
  sudo chef-server-ctl stop

  # check if required dirs exist
  if [ ! -d $LOCAL_CHEF_PEM ]; then
    mkdir $LOCAL_CHEF_PEM
  fi;

  if [ ! -d $LOCAL_CHEF_REPO ]; then
    mkdir $LOCAL_CHEF_REPO
  fi;
}

startChef() {
  echo "=> Restarting Chef server..."
  sudo chef-server-ctl start

  # Sleepy head!
  echo "=> Sleeping for 20 seconds for server to catch up"
  sleep 20
}

setupChef() {
  # Copy to user .chef
  sudo cp $CHEF_SERVER_PEM/* $LOCAL_CHEF_PEM/
  # sudo chown -R vagrant:vagrant $LOCAL_CHEF_PEM/*

  # Copy to default dir
  sudo cp $CHEF_SERVER_PEM/* $LEGACY_CHEF_PEM/
  # sudo chown -R vagrant:vagrant $LEGACY_CHEF_PEM/*

  # Rename for legacy options, maybe these are already cli options?
  sudo mv $LEGACY_CHEF_PEM/chef-webui.pem $LEGACY_CHEF_PEM/webui.pem
  sudo mv $LEGACY_CHEF_PEM/chef-validator.pem $LEGACY_CHEF_PEM/validation.pem

  echo "=> Copied Chef pems."
  echo
  
  startChef

  # Run Knife configure
  knife configure -i -s "https://$CHEF_IP" -u "admin" -r "$LOCAL_CHEF_REPO" --defaults -y

  # Runs as root, and if we accept defaults dumps knife.rb in root.
  # Move it.
  mv /root/.chef/knife.rb $LOCAL_CHEF_PEM/

  # Safety check to chown it all again
  sudo chown vagrant:vagrant $LOCAL_CHEF_PEM/knife.rb
  sudo chown -R vagrant:vagrant $LOCAL_CHEF_PEM
  sudo chown -R vagrant:vagrant $LOCAL_CHEF_REPO
}

testChef() {
  # Wake up!
  echo "=> Pinging server with silent curl to wake it up..."
  curl -ik https://$CHEF_IP
  echo "\n=> Server should be awake!?"

  # No seriously, WAKE UP (JVM warmup)!
  echo "=> Sleeping for another 10 seconds for groggy server to wake up..."
  sleep 10

  echo "Testing knife:"
  knife client list
}

# reconfigure only if we haven't already done so
if [ ! -e $CHEF_PRIV/knife.rb ]; then
  prepareChef
  setupChef
  testChef
else
  prepareChef
  startChef
  testChef
fi;

