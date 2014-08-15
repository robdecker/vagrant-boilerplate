#!/bin/bash

if [ -d "/home/vagrant/.drush" ]; then
  rm -Rf "/home/vagrant/.drush"
fi

mkdir "/home/vagrant/.drush"

chown "vagrant:vagrant" "/home/vagrant/.drush"
