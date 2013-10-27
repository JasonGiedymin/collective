#!/bin/bash
#
# modify_sshd_config.sh
#

file=/etc/ssh/sshd_config
cp -p $file $file.old &&
while read key other
do
  case $key in
    PasswordAuthentication) other=yes;;
    PubkeyAuthentication) other=yes;;
  esac
  
  echo "$key $other"
done < $file.old > $file

service ssh restart