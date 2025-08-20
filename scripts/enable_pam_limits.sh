#!/bin/bash

ulimit -Hn
ulimit -Sn

cd /etc/pam.d

sudo sed -i.bak '/pam_systemd.so/a session required   pam_limits.so' common-session
sudo sed -i.bak '/pam_unix.so/a session required   pam_limits.so' common-session-noninteractive

sudo reboot
