#!/bin/bash

set -e

sudo systemctl enable anydesk
sudo systemctl enable arpwatch
sudo systemctl enable avahi-daemon
sudo systemctl enable bacula-fd
sudo systemctl enable bacula-sd
sudo systemctl enable clamav-daemon
sudo systemctl enable clamav-freshclam
sudo systemctl enable cups-browsed
sudo systemctl enable cups
sudo systemctl enable docker
sudo systemctl enable etc-setserial
sudo systemctl enable hostapd
sudo systemctl enable irqbalance
sudo systemctl enable lm-sensors
sudo systemctl enable ntp
sudo systemctl enable o2cb
sudo systemctl enable ocfs2
sudo systemctl enable openvpn
sudo systemctl enable rsync
sudo systemctl enable setserial
sudo systemctl enable ssh
sudo systemctl enable sysstat
sudo systemctl enable smartmontools
sudo systemctl enable teamviewerd
