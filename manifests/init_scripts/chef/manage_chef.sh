#!/bin/bash
#
#
# manage_chef.sh


#
# Incudes
# =============
#

. /home/vagrant/manifests/init_scripts/lib_functions.sh

# echo "Loading ruby, berkshelf, and uploading cookbooks..."

# sudo rvm install ruby-2.0.0-p247
# rvm use ruby-2.0.0-p247
# sudo gem install berkshelf --no-ri --no-rdoc # to install in root local
cd manifests/berkshelf
# sudo berks install --path ./cookbooks -c ./berks-config.json
berks upload -c ./berks-config.json

# echo "Cookbooks loaded."

# cd $LOCAL_CHEF_REPO
# git init
# git checkout -b master
# echo "HELLO WORLD" >> README.md
# git add -A
# git commit -m "Initial Commit"
# cd $LOCAL_CHEF_REPO
# sudo knife cookbook site install git
# Looking for bootstrap? See rake!

# with a repo you can install cookbooks
# sudo knife cookbook site install git

# after installing, you can upload to server
# sudo knife cookbook upload -a