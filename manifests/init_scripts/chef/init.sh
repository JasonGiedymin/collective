#!/bin/bash
echo "Hello World!"

# Clean the house before the guests arrive...
sudo apt-get update
sudo apt-get install -y language-pack-en
sudo apt-get install -y git vim
sudo apt-get autoclean
sudo apt-get autoremove

# Install Chef
# echo "Installing Chef Server"
# sudo dpkg -i package_file.deb manifests/downloads/chefserver.deb
# sudo chef-server-ctl reconfigure