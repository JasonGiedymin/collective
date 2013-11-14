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
source /usr/local/rvm/scripts/rvm

type rvm | head -n 1


#
# Handle Pems
# =============
#

CHEF_SERVER_PEM=/etc/chef-server
LEGACY_CHEF_PEM=/etc/chef
LOCAL_CHEF_PEM=/home/$CHEF_USER/.chef
ROOT_CHEF_PEM=/root/.chef
LOCAL_CHEF_REPO=/home/$CHEF_USER/cookbooks


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
  # Copy to user and root `.chef` dir
  sudo cp $CHEF_SERVER_PEM/* $LOCAL_CHEF_PEM/

  # Copy to default dir
  sudo cp $CHEF_SERVER_PEM/* $LEGACY_CHEF_PEM/

  # Rename for legacy options, maybe these are already cli options?
  sudo mv $LEGACY_CHEF_PEM/chef-webui.pem $LEGACY_CHEF_PEM/webui.pem
  sudo mv $LEGACY_CHEF_PEM/chef-validator.pem $LEGACY_CHEF_PEM/validation.pem

  echo "=> Copied Chef pems."
  echo
  
  startChef

  rvm use system

  # Run Knife configure
  #!! for some reason ruby 1.9.3 doesn't work correctly with knife!
  knife_cmd="$KNIFE configure -i -s https://$CHEF_IP -u admin -r $LOCAL_CHEF_REPO --admin-client-key $LOCAL_CHEF_PEM/admin.pem --defaults -y"
  echo "knife command to run:"
  echo "=> $knife_cmd"

  $knife_cmd

  rvm use default

  # echo "=> Creating client cluster_node..."
  # $KNIFE client create cluster_node --disable-editing

  # echo "password" | knife configure -i -s "https://$CHEF_IP" -u "admin" -r "$LOCAL_CHEF_REPO" --defaults -y

  # Runs as root, and if we accept defaults dumps knife.rb in root.
  # Copy it.
  sudo cp $CHEF_SERVER_PEM/* $ROOT_CHEF_PEM/
  sudo cp $CHEF_SERVER_PEM/* $ROOT_CHEF_PEM/
  cp /root/.chef/knife.rb $LOCAL_CHEF_PEM/

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
if [ ! -e $LOCAL_CHEF_PEM/knife.rb ]; then
  echo "=> Setting up chef and knife for the first time..."
  prepareChef
  setupChef
  testChef
else
  echo "=> Chef and Knife already set up, recycling server..."
  prepareChef
  startChef
  testChef
fi;

