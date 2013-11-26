#!/bin/bash

#
# Incudes
# =============
#
. /home/vagrant/manifests/init_scripts/lib_functions.sh


#
# This script installs Mesos, Marathon from source
#
# Great resource for starting mesos + zookeeper
# http://mesosphere.io/2013/08/01/distributed-fault-tolerant-framework-apache-mesos/
#
# Great tutorial: https://github.com/mesosphere/mesos-docker/blob/master/tutorial.md
#

VER_MESOS="0.14.2"
VER_MARATHON="0.2.2"

sudo apt-get update

# sudo apt-get install -y libcppunit-dev libunwind7-dev \
# python-setuptools gcc g++ ccache libltdl-dev \
# java7-runtime-headless libtool autoconf autopoint \
# autotools-dev make python-dev

# Bare minimum required
sudo apt-get install -y g++ gcc ccache python-setuptools python-dev \
libcurl4-openssl-dev libunwind7-dev zookeeper-bin zookeeperd

# adds which are temporary for now
sudo apt-get install -y screen unzip curl

sudo easy_install httpie

if [ ! -d temp ]; then
  echo "== Creating temp dir... =="
  mkdir temp
fi

cd temp

if [ ! -d ~/temp/mesos ]; then
  echo "== Downloading mesos... =="
  curl http://apache.mirrors.pair.com/mesos/$VER_MESOS/mesos-$VER_MESOS.tar.gz > ~/temp/mesos.tar.gz

  echo "== Un-compressing tar... =="
  tar -xvf mesos.tar.gz
fi;

cd mesos-$VER_MESOS

echo "== Configure... =="
./configure --disable-perftools

echo "== Making... =="
make clean
make
sudo make uninstall
sudo make install

if [ ! -e /usr/lib/libmesos-$VER_MESOS.so ]; then
  echo "== Linking shared lib... =="
  sudo ln -s /usr/local/lib/libmesos-$VER_MESOS.so /usr/lib/libmesos-$VER_MESOS.so
  sudo ln -s /usr/local/bin/mesos* /usr/local/

  echo "== Also creating dependencies for upstart and friends... =="
  sudo mkdir -p /usr/share/doc/mesos /etc/default /etc/mesos /var/log/mesos
fi

cd ~/temp

echo "== Cloning Marathon... =="
git clone https://github.com/mesosphere/marathon.git
cd marathon

echo "== Building Marathon... =="
mvn clean
mvn compile
mvn package


cd target

echo "== Preparing marathon dest... =="
if [ ! -d /opt/marathon ]; then
  sudo mkdir -p /opt/marathon/ 
fi

echo "== Preparing marathon dest etc... =="
if [ ! -d /etc/marathon ]; then
  sudo mkdir -p /etc/marathon
fi

sudo cp -f ~/temp/marathon/target/marathon-$VER_MARATHON-SNAPSHOT-jar-with-dependencies.jar /opt/marathon/marathon.jar
sudo chmod ug+rx /opt/marathon/marathon.jar

sudo cp -f /home/vagrant/manifests/downloads/marathon.conf /etc/init/marathon.conf

echo "== Preparing mesos-docker =="
if [ /var/lib/mesos ]; then
  sudo mkdir -p /var/lib/mesos
fi

if [ /var/lib/mesos/executors ]; then
  sudo mkdir -p /var/lib/mesos/executors
fi

echo "== Installing mesos-docker =="
sudo cp -f /home/vagrant/manifests/repos/mesos-docker/bin/mesos-docker /var/lib/mesos/executors/docker

sudo restart zookeeper
sudo restart mesos-local
sudo restart marathon


# Mesos UI
# http://10.10.10.14:5050/#/

# Marathon UI
# http://10.10.10.14:8080/#

# run redis test
# http POST http://localhost:8080/v1/apps/start \
# id=multidis instances=1 mem=512 cpus=1 \
# executor=/var/lib/mesos/executors/docker \
# cmd='johncosta/redis'

# http GET http://localhost:8080/v1/endpoints

# sudo docker run -i -t johncosta/redis redis-cli -h 

# sudo docker ps -a
# sudo docker inspect <insert running docker hash here>
# sudo docker 




