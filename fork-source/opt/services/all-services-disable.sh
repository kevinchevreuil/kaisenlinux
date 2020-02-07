#!/bin/bash

set -e

sudo systemctl disable anydesk
sudo systemctl disable avahi-daemon
sudo systemctl disable clamav-daemon
sudo systemctl disable clamav-freshclam
sudo systemctl disable cups-browsed
sudo systemctl disable cups
sudo systemctl disable docker
sudo systemctl disable openvpn
sudo systemctl disable rsync
sudo systemctl disable smartmontools
sudo systemctl disable teamviewerd

