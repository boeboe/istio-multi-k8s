#!/usr/bin/env bash

echo "Upgrade packages and distro"
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get -y auto-remove

echo "Enable systemd-resolved service"
sudo systemctl start systemd-resolved.service
sudo systemctl enable systemd-resolved.service
