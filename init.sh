#!/bin/bash
set -e  # Exit immediately if a command fails

# Determine the real user and home dir whether run with sudo or not
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(eval echo "~$REAL_USER")

sudo apt update && sudo apt -y upgrade

echo "Configure setup to make it interact with attached hardware. enable SPI for EPD displays"
sleep 5
sudo raspi-config

sudo apt install -y python3

# Create a default environment for all python installations
python3 -m venv --system-site-packages "$REAL_HOME/env"

# Make a directory for startup programs
mkdir -p "$REAL_HOME/base-boot"

# Copy startup files
cp -r "$REAL_HOME/rpi-02w-setup/base-boot" "$REAL_HOME/base-boot/"

# Crontab setup
echo "__________________Crontab content, you have 10 seconds to copy the content below this line ______________________"
cat "$REAL_HOME/rpi-02w-setup/root"
sleep 10
echo "__________________paste this into the window that appears next______________________"
sudo crontab -e
sleep 5

curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale set --operator="$REAL_USER"

read -p "Enter your Tailscale auth key: " AUTH_KEY
tailscale up -ssh --authkey "$AUTH_KEY"

cd "$REAL_HOME"
sudo apt install -y zsh
RUNZSH=no CHSH=no sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# Zsh plugins
mkdir -p "$REAL_HOME/.zsh/plugins"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$REAL_HOME/.zsh/plugins/zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$REAL_HOME/.zsh/plugins/zsh-autosuggestions"

# Append plugin config and aliases to .zshrc
cat >> "$REAL_HOME/.zshrc" <<EOF

# Load zsh plugins
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
alias rcedit='nano ~/.zshrc'
alias refsh='source ~/.zshrc'
source ~/env/bin/activate
EOF

# Set default shell to Zsh for the real user
chsh -s "$(which zsh)" "$REAL_USER"

sudo apt -y autoremove
echo "✅ Reboot the system to get the new changes by running: sudo reboot now"
