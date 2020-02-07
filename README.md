# kaisenlinux

This repository contain all sources for building Kaisen Linux ISO. 

Kaisen Linux ISO building with live-build tool, this official tool for building officials Debian images.

Install live-build :

sudo apt-get install live-build live-tools 

Test with this repository :)

The tools integrated into Kaisen Linux are integrated with .deb packages but are not contained in this repository because no possibility of committing them (too large) but a list of essential software installed is available on the official Kaisen Linux website.

To know the list of all the tools installed on Kaisen Linux (.deb files initially listed in the packages.chroot folder) type the command: sudo dpkg --get-selections on the live Kaisen Linux
