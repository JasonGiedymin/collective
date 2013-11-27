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

TEMP_DIR=/home/vagrant/temp
VER_MESOS="0.14.2"
MESOS_DIR=$TEMP_DIR/mesos-$VER_MESOS


if [ ! -d $TEMP_DIR ]; then
  echo "== Creating temp dir... =="
  mkdir $TEMP_DIR
fi

if [ ! -d $MESOS_DIR ]; then
  echo "== Downloading mesos... =="
  curl http://apache.mirrors.pair.com/mesos/$VER_MESOS/mesos-$VER_MESOS.tar.gz > $TEMP_DIR/mesos-$VER_MESOS.tar.gz

  echo "== Un-compressing tar... =="
  cd $TEMP_DIR
  tar -xvf mesos.tar.gz
fi;

cd $MESOS_DIR

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

if [ ! -e /etc/init/mesos-master.conf ]; then
  sudo cp /home/vagrant/manifests/repos/mesos-deb-packaging/ubuntu/master.upstart \
  /etc/init/mesos-master.conf
fi

if [ ! -e /etc/init/mesos-slave.conf ]; then
  sudo cp /home/vagrant/manifests/repos/mesos-deb-packaging/ubuntu/slave.upstart \
  /etc/init/mesos-slave.conf
fi

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




