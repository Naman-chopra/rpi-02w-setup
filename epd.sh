#!/bin/bash
#set -e

# Determine real user and home
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(eval echo "~$REAL_USER")

# Activate virtual environment
source "$REAL_HOME/env/bin/activate"

# Install GPIO libraries and build lg library
cd "$REAL_HOME"
wget https://github.com/joan2937/lg/archive/master.zip
unzip master.zip
cd lg-master
make
sudo make install
sudo apt -y install gpiod libgpiod-dev python3-pip

# Clone Waveshare Touch display repo and install
cd "$REAL_HOME"
git clone "https://github.com/waveshare/Touch_e-Paper_HAT"
sudo chown -R "$REAL_USER:$REAL_USER" "$REAL_HOME/Touch_e-Paper_HAT"
pip install Touch_e-Paper_HAT/python/

sudo apt -y autoremove

cd "$REAL_HOME/rpi-02w-setup"
pip install -r requirements.txt

echo "LOOK AT YOUR DISPLAY"
cd "$REAL_HOME"
sudo rm -rf master.zip
python3 base-boot/scripts/epd/helloworld.py
