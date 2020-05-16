#!/bin/sh

#lsb-release install for move Debian GRUB entries by Kaisen GRUB entries (manual install after OS install for fix bug minimal-bash like)
mv /opt/lsb_release /usr/bin
mv /opt/lsb_release.py /usr/share/pyshared
cd /usr/lib/python2.7/dist-packages
ln -s ../../../share/pyshared/lsb_release.py ./
cd /usr/lib/python3/dist-packages
ln -s ../../../share/pyshared/lsb_release.py ./

#GRUB entries personnalize (added GRUB wallpaper even with encrypted disk and remove memtest86+ entries)
cp /usr/share/desktop-base/kaisen-theme/grub/grub-16x9.png /boot/grub
mv /opt/05_debian_theme /etc/grub.d/
mv /opt/grub /etc/default/grub
rm /etc/grub.d/20_memtest86+
lsb_release -i -s
update-grub
