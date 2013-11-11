#!/bin/bash
#
# This script was created so that there was no reliance on vagrant other than
# a means to push params.
#


#
# Incudes
# =============
#

. /home/vagrant/manifests/init_scripts/lib_functions.sh

#
# Bootstrap
# =============
#

bootstrap() {
  if [ $# -lt 3 ]; then
    echo "bad"
    exit
  fi
  
  command="knife bootstrap $2 -x $3 -P $4 --sudo"
  echo "Running => [$command]"
  eval $command
}

case "$1" in
  bootstrap)
    bootstrap $@
    ;;
  *)
    echo "Usage: $FULLPATH {bootstrap} <ip> --sudo -x <user> -p <password>"
    exit 1
    ;;
esac