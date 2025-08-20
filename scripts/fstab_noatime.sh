#!/bin/bash

df -h
sudo cat /proc/mounts

cd /etc

sudo sed -i.bak '/ext4/ s/defaults/defaults,noatime/' fstab

sudo reboot
