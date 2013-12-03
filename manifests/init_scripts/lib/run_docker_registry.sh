#!/bin/bash

#
# Incudes
# =============
#
. /home/vagrant/manifests/init_scripts/lib_functions.sh

installRegistry() {
  echo "Running docker-registry docker container..."
  sudo docker pull samalba/docker-registry
  sudo docker run -d -p 5000:5000 samalba/docker-registry
  echo "Checking for docker-registry response:"
  curl -L http://10.10.10.10:5000/v1/_ping
}

# Only install if it doesn't exist
sleep 20s # wait 10s for registry to run
STATUS=$(curl -s -o /dev/null -w '%{http_code}' http://10.10.10.10:5000/v1/_ping)
if [ $STATUS != 200 ]; then
  installRegistry
else
  echo
  echo "* docker-registry already installed and running on http://10.10.10.10:5000"
  echo "  status code was [$STATUS]"
  echo
fi
