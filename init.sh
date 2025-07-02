#!/bin/bash
set -e

# Determine real user and their home directory
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(eval echo "~$REAL_USER")

# # Ask for sudo once up front
# sudo -v

# System updates (needs sudo)
sudo apt update && sudo apt -y upgrade

echo "Configure setup to make it interact with attached hardware. Enable SPI for EPD displays"
sleep 5
sudo raspi-config

# Install python if needed
sudo apt install -y python3

# Create Python venv in user home
python3 -m venv --system-site-packages "$REAL_HOME/env"

# Setup directories
mkdir -p "$REAL_HOME/base-boot"
cp -r "$REAL_HOME/rpi-02w-setup/base-boot/." "$REAL_HOME/base-boot/"

# Cron job
echo "__________________Crontab content, copy below ______________________"
cat "$REAL_HOME/rpi-02w-setup/root"
sleep 10
echo "__________________paste this into the window that appears next______________________"
sudo crontab -e
sleep 5

# Tailscale install
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale set --operator="$REAL_USER"
read -p "Enter your Tailscale auth key: " AUTH_KEY
tailscale up -ssh --authkey "$AUTH_KEY"

# ZSH setup
sudo apt install -y zsh
cd "$REAL_HOME"
RUNZSH=no CHSH=no sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# Plugins
mkdir -p "$REAL_HOME/.zsh/plugins"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$REAL_HOME/.zsh/plugins/zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$REAL_HOME/.zsh/plugins/zsh-autosuggestions"

# Set default shell
sudo chsh -s /usr/bin/zsh

# .zshrc additions
cat >> "$REAL_HOME/.zshrc" <<EOF

# Load zsh plugins
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
alias rcedit='nano ~/.zshrc'
alias refsh='source ~/.zshrc'
source ~/env/bin/activate
EOF

sudo apt -y autoremove

echo "✅ All done. Reboot with: sudo reboot now"
