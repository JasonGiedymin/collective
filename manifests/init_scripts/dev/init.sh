#!/bin/bash
echo "Hello World!"

# Clean the house before the guests arrive...
sudo apt-get update
sudo apt-get install -y language-pack-en
sudo apt-get install -y git vim
sudo apt-get autoclean
sudo apt-get autoremove


cd manifests/devstack
# ./stack.sh
