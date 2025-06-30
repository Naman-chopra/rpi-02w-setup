source ~/env/bin/activate
#installing all the libraries and drivers needed for the waveshare touch display
wget https://github.com/joan2937/lg/archive/master.zip
unzip master.zip
cd lg-master
make
sudo make install
sudo apt install gpiod libgpiod-dev python3-pip

git clone https://github.com/waveshare/Touch_e-Paper_HAT
cd ~/Touch_e-Paper_HAT/python/
python3 setup.py install

cd ~/rpiz2wFirstBoot

pip install -r requirements.txt