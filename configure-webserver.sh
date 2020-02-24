#!/bin/bash 
if [ -z $1 ]; then
  echo "Please pass user"
  echo "USAGE: ./$0 username"
  exit 1
fi

CURRENT_USER=$(getent passwd root  | awk -F: '{ print $6 }')
chmod 0775 ${CURRENT_USER}/install-dir/*.ign
cp -avi ${CURRENT_USER}/install-dir/*.ign /var/www/html/ignition/

if [ -d ${CURRENT_USER}/ocp4-utils/ ]; then
  chmod 0775 ${CURRENT_USER}/ocp4-utils/configFiles/*.com
  cp -avi ${CURRENT_USER}/ocp4-utils/configFiles/*.com  /var/www/html/ignition/
fi

cd /var/www/html/ignition/
restorecon -RFv .