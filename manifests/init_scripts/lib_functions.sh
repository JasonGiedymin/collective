#!/bin/bash
#
# lib_functions.sh
#

#
# Guard
# =============
#
# if [ $0 != "-bash" ]; then
#     echo "Do not run this script stand alone!"
#     echo "<= Exiting."
#     exit;
# fi;


export CHEF_USER=vagrant
export CHEF_IP="10.10.10.10"
export KNIFE=/opt/vagrant_ruby/bin/knife
export HOME_CHEF_USER=/home/vagrant
export HOME_SCRIPTS=$HOME_CHEF_USER/manifests
export HOME_RESOURCES=$HOME_SCRIPTS/resources
export TEMP_DIR=$HOME_CHEF_USER/temp


function info() {
  echo
  echo "****************************"
  echo " Sourced lib_functions Info"
  echo "****************************"
  echo "Running User=$USER"
  echo "CHEF_USER=$CHEF_USER"
  echo "CHEF_IP=$CHEF_IP"
  echo "****************************"
  echo
}

function upload() {
  if [ ! -d $2 ]; then
    mkdir -p $2
  fi

  if [ ! -e $1 ]; then
    echo "Nothing to upload."
  else
    if [ ! -e $2/$3 ]; then
      echo "== Uploading [$1] to [$2/$3] =="
      cp -f $1 $2/$3
    else
      echo "File already exists, not uploading."
    fi
  fi
}

function safeCopy() {
  if [ ! -e $2 ]; then
    sudo cp $1 $2
  fi
}

function serviceAction() {
  if [ -e /etc/init/$1.conf ]; then
    sudo service $1 $2
    echo "== action $2 on $1 complete =="
  fi;  
}

