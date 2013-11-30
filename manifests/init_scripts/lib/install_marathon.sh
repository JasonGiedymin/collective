#!/bin/bash
#
# Far simpler script than install_mesos
# This script will install the jar if available
# otherwise, it will compile it and store it
# for future use.
# Script will also copy configs over.
#


#
# Incudes
# =============
#
. /home/vagrant/manifests/init_scripts/lib_functions.sh


TEMP_DIR=$HOME_CHEF_USER/temp
VER_MARATHON="0.2.2"
MARATHON_DIR=$TEMP_DIR/marathon

MODULE_MARATHON=/opt/marathon/marathon.jar
MODULE_COMPILED_FILENAME=marathon-$VER_MARATHON-SNAPSHOT-jar-with-dependencies.jar
MODULE_UPLOAD_PATH=$HOME_RESOURCES/marathon
MODULE_UPLOAD_FILE=$MARATHON_DIR/target/$MODULE_COMPILED_FILENAME

function prepare() {
  echo "== Preparing marathon dest... =="
  if [ ! -d /opt/marathon ]; then
    sudo mkdir -p /opt/marathon/ 
  fi

  echo "== Preparing marathon dest etc... =="
  if [ ! -d /etc/marathon ]; then
    sudo mkdir -p /etc/marathon
  fi
}

function compile() {
  echo "== Cloning Marathon... =="
  if [ ! -e $MARATHON_DIR ]; then
    git clone https://github.com/mesosphere/marathon.git $MARATHON_DIR
  fi

  local pre_packaged_jar=$MODULE_UPLOAD_PATH/$MODULE_COMPILED_FILENAME
  if [ ! -e $pre_packaged_jar ]; then
    echo "== Building Marathon... =="
    cd $MARATHON_DIR
    mvn clean
    mvn compile
    mvn package
  fi
}

function linkSrc() {
  cd $MARATHON_DIR/target

  sudo cp -f $1 /opt/marathon/marathon.jar
  sudo chmod ug+rx /opt/marathon/marathon.jar
  sudo cp -Rf $MODULE_UPLOAD_PATH/ubuntu /
}

function link() {
  local pre_packaged_jar=$MODULE_UPLOAD_PATH/$MODULE_COMPILED_FILENAME
  if [ -e $pre_packaged_jar ]; then
    linkSrc $pre_packaged_jar
  else
    linkSrc $MODULE_UPLOAD_FILE
  fi
}

if [ ! -e $MODULE_MARATHON ]; then
  echo "== Setting up Marathon... =="
  prepare
  compile
  link
  upload $MODULE_UPLOAD_FILE $MODULE_UPLOAD_PATH $MODULE_COMPILED_FILENAME
else
  echo "== Marathon already installed, skipping. =="
fi
