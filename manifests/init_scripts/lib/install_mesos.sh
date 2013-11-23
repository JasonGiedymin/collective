#!/bin/bash

#
# Incudes
# =============
#
. /home/vagrant/manifests/init_scripts/lib_functions.sh


#sudo apt-get install -y python2.7-dev libcppunit-dev libunwind7-dev libcurl4-openssl-dev
sudo apt-get install -y libcppunit-dev libunwind7-dev \
python-setuptools gcc g++ autotools-dev libltdl-dev \
libtool autoconf autopoint java7-runtime-headless
# sudo apt-get install -y libc6

# if [ ! -d mesos-0.14.2 ]; then
#   wget http://mirror.tcpdiag.net/apache/mesos/0.14.2/mesos-0.14.2.tar.gz
# fi

# tar -xvf mesos-0.14.2.tar.gz
# rm mesos-0.14.2.tar.gz
# cd mesos-0.14.2
# ./configure

# ubuntu user needed for python
if [ ! -e /home/ubuntu ]; then
  useradd -m --home /home/ubuntu --shell /bin/bash ubuntu
fi

# add vagrant
gpasswd -a vagrant docker

echo "Installing Mesos..."
# curl -fL https://raw.github.com/mesosphere/mesos-docker/master/bin/mesos-docker-setup | sudo bash

sudo dpkg -i ~/manifests/downloads/mesos_14_64.deb
