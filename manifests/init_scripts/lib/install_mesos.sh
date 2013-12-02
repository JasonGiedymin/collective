#!/bin/bash
#
#
# This script installs Mesos, Marathon from source
#
# Note: do not use ccache with mesos :-)
# 

#
# Incudes
# =============
#
. /home/vagrant/manifests/init_scripts/lib_functions.sh


# Great resource for starting mesos + zookeeper
# http://mesosphere.io/2013/08/01/distributed-fault-tolerant-framework-apache-mesos/
#
# Great tutorial: https://github.com/mesosphere/mesos-docker/blob/master/tutorial.md
#
# Another: http://ampcamp.berkeley.edu/3/exercises/index.html
#          http://ampcamp.berkeley.edu/3/exercises/mesos.html

USE_SRC=false # go compiled, src building takes forever
FORCE_LINK=true # copy over upstart conf every time

# Module Info
MODULE_VERSION_SRC="0.14.2"
MODULE_VERSION_DEB="0.16.0"
MODULE_SRC_HOME=$TEMP_DIR/mesos-$MODULE_VERSION_SRC
MODULE_HOME=$TEMP_DIR/mesos-deb-packaging
MODULE_CHECK_FILE=/usr/lib/libmesos-$MODULE_VERSION_SRC.so
MODULE_COMPILED_FILENAME=mesos-$MODULE_VERSION_DEB.deb
MODULE_UPLOAD_PATH=$HOME_RESOURCES/mesos
MODULE_UPLOAD_FILE=$MODULE_HOME/$MODULE_COMPILED_FILENAME


function installDeps() {
  sudo apt-get install -y default-jre-headless default-jre python-setuptools zookeeperd
  gem install fpm
}

# mesos gets cloned twice, manually and by the deb-packager
# the deb-packager is being evaulated and I'm not ready
# to abandon manual compile
function prepare() {

  if [ ! -d $TEMP_DIR ]; then
    echo "== Creating temp dir... =="
    mkdir $TEMP_DIR
  fi

  if [ ! -d $MODULE_SRC_HOME ]; then
    echo "== Downloading mesos... =="
    curl http://apache.mirrors.pair.com/mesos/$MODULE_VERSION_SRC/mesos-$MODULE_VERSION_SRC.tar.gz > $TEMP_DIR/mesos-$MODULE_VERSION_SRC.tar.gz

    echo "== Un-compressing tar... =="
    cd $TEMP_DIR
    tar -xvf mesos-$MODULE_VERSION_SRC.tar.gz
  fi;

  local deb_package_repo=$TEMP_DIR/mesos-deb-packaging
  if [ ! -d $deb_package_repo ]; then
    echo "== Cloning package repo... =="
    git clone https://github.com/deric/mesos-deb-packaging.git $deb_package_repo
  fi
}

function compileDeb() {
  
  if [ -e $HOME_RESOURCES/mesos/$MODULE_COMPILED_FILENAME ]; then
    dpkg -i $HOME_RESOURCES/mesos/$MODULE_COMPILED_FILENAME
  else
    cd $MODULE_HOME
    ./build_mesos

    mv mesos*.deb mesos-$MODULE_VERSION_DEB.deb

    dpkg -i $MODULE_UPLOAD_FILE

    if [ -e $MODULE_UPLOAD_FILE ]; then
      upload $MODULE_UPLOAD_FILE $MODULE_UPLOAD_PATH $MODULE_COMPILED_FILENAME
    fi
  fi
}

function compileSrc() {
  cd $MODULE_SRC_HOME

  echo "== Configure... =="
  ./configure # --disable-perftools # perftools must be disabled for Fedora/Centos branch

  echo "== Making... =="
  make clean
  make
  sudo make uninstall
  sudo make install
}

function compile() {
  compileDeb
}

function linkLib() {
  if [ ! -e /usr/lib/libmesos-$MODULE_VERSION_SRC.so ]; then
    echo "== Linking shared lib... =="
    sudo ln -s -f /usr/local/lib/libmesos-$MODULE_VERSION_SRC.so /usr/lib/libmesos-$MODULE_VERSION_SRC.so
    sudo ln -s -f /usr/local/bin/mesos* /usr/local/

    echo "== Also creating dependencies for upstart and friends... =="
    sudo mkdir -p /usr/share/doc/mesos /etc/default /etc/mesos /var/log/mesos
  fi
}

function linkSrc() {
  linkLib
  
  safeCopy /home/vagrant/manifests/repos/mesos-deb-packaging/ubuntu/master.upstart \
  /etc/init/mesos-master.conf

  safeCopy /home/vagrant/manifests/repos/mesos-deb-packaging/ubuntu/slave.upstart \
  /etc/init/mesos-slave.conf

}

function linkDeb() {
  linkLib

  # Blanket copy ubuntu config to root
  sudo cp -Rf $MODULE_UPLOAD_PATH/ubuntu/* /
}

function install_module() {
  if [ ! -h $MODULE_CHECK_FILE ]; then
    installDeps
    prepare

    if [ $USE_SRC == true ]; then
      echo "== Installing Mesos via SRC... =="
      compileSrc
      linkSrc
    else
      echo "== Installing Mesos via DEB... =="
      compileDeb
      linkDeb
    fi

  else
    echo "== Mesos already installed, skipping. =="

    # Force Actions
    if ( $USE_SRC == true && $FORCE_LINK == true ); then
      echo "== FORCE linking Mesos via SRC... =="
      linkSrc
    else
      echo "== FORCE linking Mesos via DEB... =="
      linkDeb
    fi    
  fi  
}

install_module


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




