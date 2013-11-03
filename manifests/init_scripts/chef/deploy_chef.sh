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
# sudo dpkg -i package_file.deb manifests/downloads/chefserver.deb
sudo chef-server-ctl reconfigure
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

