#!/bin/bash

#
# Incudes
# =============
#
. /home/vagrant/manifests/init_scripts/lib_functions.sh


TEMP_DIR=/home/vagrant/temp
VER_MARATHON="0.2.2"
MARATHON_DIR=$TEMP_DIR/marathon


echo "== Cloning Marathon... =="
if [ ! -e $MARATHON_DIR ]; then
  git clone https://github.com/mesosphere/marathon.git $MARATHON_DIR
fi

cd $MARATHON_DIR

echo "== Building Marathon... =="
mvn clean
mvn compile
mvn package

cd $MARATHON_DIR/target

echo "== Preparing marathon dest... =="
if [ ! -d /opt/marathon ]; then
  sudo mkdir -p /opt/marathon/ 
fi

echo "== Preparing marathon dest etc... =="
if [ ! -d /etc/marathon ]; then
  sudo mkdir -p /etc/marathon
fi

sudo cp -f $MARATHON_DIR/target/marathon-$VER_MARATHON-SNAPSHOT-jar-with-dependencies.jar /opt/marathon/marathon.jar
sudo chmod ug+rx /opt/marathon/marathon.jar

sudo cp -f /home/vagrant/manifests/downloads/marathon.conf /etc/init/marathon.conf
