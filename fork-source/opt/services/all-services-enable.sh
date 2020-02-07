#!/bin/bash

set -e

sudo systemctl enable anydesk
sudo systemctl enable avahi-daemon
sudo systemctl enable clamav-daemon
sudo systemctl enable clamav-freshclam
sudo systemctl enable cups-browsed
sudo systemctl enable cups
sudo systemctl enable docker
sudo systemctl enable openvpn
sudo systemctl enable rsync
sudo systemctl enable smartmontools
sudo systemctl enable teamviewerd

