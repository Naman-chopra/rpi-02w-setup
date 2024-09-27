#!/bin/bash

# configure the vnc server, vnc resolution, update the pi and other hardware interfaces
sudo raspi-config

# creating a default environment for all python installations
python3 -m venv --system-site-packages ~/env

# making a directory for startup programs
mkdir ~/startup

# adding ip updation email to 
cp mail_upd.py ~/startup/

#copy bashrc file to ensure the environment is activated on every login and some other customizations
cp .bashrc ~/.bashrc

# setting cronjobs to use the mail updation script to run at startup
# add commands to run other files to the root file at startup or periodically
cp root ~/var/spool/cron/crontabs/root

sudo reboot now