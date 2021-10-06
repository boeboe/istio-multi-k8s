#!/usr/bin/env bash

echo "Upgrade packages and distro"
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get -y auto-remove
