#!/bin/bash
source ~/env/bin/activate
#installing all the libraries and drivers needed for the waveshare touch display
cd
wget https://github.com/joan2937/lg/archive/master.zip
unzip master.zip
cd lg-master
make
sudo make install
sudo apt -y install gpiod libgpiod-dev python3-pip

cd
git clone https://github.com/waveshare/Touch_e-Paper_HAT
python3 Touch_e-Paper_HAT/python/setup.py install

sudo apt -y autoremove

cd ~/rpi-02w-setup

pip install -r requirements.txt


echo "LOOK AT YOUR DISPLAY"
python3 base-boot/scripts/epd/helloworld.py