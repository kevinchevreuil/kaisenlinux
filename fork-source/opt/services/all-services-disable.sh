#!/bin/bash

set -e

sudo systemctl disable anydesk
sudo systemctl disable arpwatch
sudo systemctl disable avahi-daemon
sudo systemctl disable bacula-fd
sudo systemctl disable bacula-sd
sudo systemctl disable clamav-daemon
sudo systemctl disable clamav-freshclam
sudo systemctl disable cups-browsed
sudo systemctl disable cups
sudo systemctl disable docker
sudo systemctl disable etc-setserial
sudo systemctl disable hostapd
sudo systemctl disable irqbalance
sudo systemctl disable lm-sensors
sudo systemctl disable ntp
sudo systemctl disable o2cb
sudo systemctl disable ocfs2
sudo systemctl disable openvpn
sudo systemctl disable rsync
sudo systemctl disable setserial
sudo systemctl disable ssh
sudo systemctl disable sysstat
sudo systemctl disable smartmontools
sudo systemctl disable teamviewerd
