#!/bin/bash
cd
sudo apt install zsh
RUNZSH=no sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# Create a directory for Zsh custom plugins
mkdir -p ~/.zsh/plugins

# Clone both plugins into the same location
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions

# Add sourcing lines to .zshrc if not already present
{
  echo ""
  echo "# Load zsh plugins"
  echo "source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  echo "source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
} >> ~/.zshrc

sudo reboot now
sudo apt update && sudo apt upgrade
# configure the vnc server, vnc resolution, update the pi and other hardware interfaces
echo "Configure setup to make it interact with attached hardware. enable SPI for EPD displays"
sleep 5
sudo raspi-config

sudo apt install python3
# creating a default environment for all python installations
python3 -m venv --system-site-packages ~/env

# making a directory for startup programs
mkdir ~/base-boot

# adding ip updation email to 
cp -r ~/rpiz2wFirstBoot/base-boot ~/base-boot/

#copy bashrc file to ensure the environment is activated on every login and some other customizations
echo "alias rcedit='nano ~/.zshrc'" >> ~/.zshrc
echo "alias refsh='source ~/.zshrc'" >> ~/.zshrc
echo "source ~/env/bin/activate" >> ~/.zshrc

# setting cronjobs to use the mail updation script to run at startup
# add commands to run other files to the root file at startup or periodically
echo "__________________Crontab content, you have 10 seconds to copy the content below this line ______________________"
cat root
sleep 10
echo "__________________paste this into the window that appears next______________________"
sudo crontab -e
sleep 5

curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale set --operator=$USER

read -p "Enter your Tailscale auth key: " AUTH_KEY
tailscale up -ssh --authkey "$AUTH_KEY"