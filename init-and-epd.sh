#!/bin/bash
echo "Running initial setup..."
echo "Make sure to enable SPI and I2C from raspi-config"

chmod +x init.sh
sudo ./init.sh

chmod +x epd.sh
sudo ./epd.sh