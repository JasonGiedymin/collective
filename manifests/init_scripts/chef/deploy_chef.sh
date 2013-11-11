#!/bin/bash
#
# deploy nodes
#
# currently this relies on the chef server being bootstrapped
# via vagrant
#

MANIFESTS=/home/$CHEF_USER/manifests
MANIFESTS_PEMS=$MANIFESTS/init_scripts/chef/files/.chef
CHEF_PRIV=/home/$CHEF_USER/.chef/

#
# Install Chef
# =============
#

# echo "Installing Chef Server"
ReInstallChef=${ReInstallChef:=true}

installChef() {
  sudo dpkg -i manifests/downloads/chefserver.deb
}

if [ $ReInstallChef = false ]; then
  echo "=> Reinstalling Chef server..."
  vagrant_chef=/home/vagrant/.chef/knife.rb
  root_chef=/root/.chef/knife.rb

  if [ -e $vagrant_chef ]; then
    sudo rm -R $vagrant_chef
  fi;
  
  if [ -e $root_chef ]; then
    sudo rm -R $root_chef 
  fi;

  installChef
else
  if [ ! -d /opt/chef-server/ ]; then
    echo "=> Chef server not found, installing server..."
    installChef
  else
    echo "=> Chef server already installed, moving on."
  fi
fi

# reconfigure only if we haven't already done so
# if [ ! -e $CHEF_PRIV/knife.rb ]; then
  # echo "First time setting up server running reconfigure..."
echo "=> Running reconfigure for good measure..."
sudo chef-server-ctl reconfigure
# fi

# Run Chef Tests
# sudo chef-server-ctl test

echo "=> Chef install complete."


#
# Display Info
# =============
#

echo
echo
echo "========================================================================="
echo "                      Chef Server Version Info "
echo "========================================================================="
curl -L -k https://10.10.10.10/version
echo "========================================================================="
echo
echo
echo "If Installation was successful you should see version info above and"
echo "the Chef server should be accessible via:"
echo "    url:  https://10.10.10.10/"
echo "    user: admin"
echo "    pass: p@ssw0rd1"
echo

