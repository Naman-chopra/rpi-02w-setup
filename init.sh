#!/bin/bash
set -e

# Determine real user and their home directory
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(eval echo "~$REAL_USER")

# Ask for sudo up front
sudo -v

# System updates
sudo apt update && sudo apt -y upgrade

echo "Configure setup to make it interact with attached hardware. Enable SPI for EPD displays"
sleep 5
sudo raspi-config

# Install Python and venv
sudo apt install -y python3 python3-venv

# Create Python venv in user home
sudo -u "$REAL_USER" python3 -m venv --system-site-packages "$REAL_HOME/env"

# Setup directories and copy files
sudo -u "$REAL_USER" mkdir -p "$REAL_HOME/base-boot"
sudo cp -r "$REAL_HOME/rpi-02w-setup/base-boot/." "$REAL_HOME/base-boot/"

# Crontab setup
echo "__________________Crontab content, copy below ______________________"
cat "$REAL_HOME/rpi-02w-setup/root"
sleep 10
echo "__________________Paste this into the window that appears next______________________"
sudo crontab -e
sleep 5

# Tailscale install
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale set --operator="$REAL_USER"
read -p "Enter your Tailscale auth key: " AUTH_KEY
tailscale up -ssh --authkey "$AUTH_KEY"

# Install ZSH and Oh My Zsh
sudo apt install -y zsh wget git

# Install Oh My Zsh as the real user (without auto-launch or chsh)
sudo -u "$REAL_USER" bash -c '
  export RUNZSH=no
  export CHSH=no
  sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
'

# Copy default zshrc template
sudo -u "$REAL_USER" cp "$REAL_HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$REAL_HOME/.zshrc"

# Plugins setup
sudo -u "$REAL_USER" mkdir -p "$REAL_HOME/.zsh/plugins"
sudo -u "$REAL_USER" git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$REAL_HOME/.zsh/plugins/zsh-syntax-highlighting"
sudo -u "$REAL_USER" git clone https://github.com/zsh-users/zsh-autosuggestions.git "$REAL_HOME/.zsh/plugins/zsh-autosuggestions"

# Set default shell to zsh
sudo chsh -s /usr/bin/zsh "$REAL_USER"

# Append custom .zshrc additions
sudo -u "$REAL_USER" bash -c "cat >> '$REAL_HOME/.zshrc'" <<EOF

# Load zsh plugins
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
alias rcedit='nano ~/.zshrc'
alias refsh='source ~/.zshrc'
source ~/env/bin/activate
EOF

# Cleanup
sudo apt -y autoremove

# Fix ownership of everything created in user's home
sudo chown -R "$REAL_USER:$REAL_USER" "$REAL_HOME"

echo "✅ All done. Reboot with: sudo reboot now"
