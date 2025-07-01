#!/bin/bash
set -e  # Exit on any failure

# Determine if running as root
if [[ "$EUID" -ne 0 ]]; then
  echo "⚠️ Script not run as root. Elevating with sudo..."
  exec sudo "$0" "$@"
fi

# Now running as root
# Determine the real user (who invoked sudo, or who is logged in)
if [ -n "$SUDO_USER" ]; then
  REAL_USER="$SUDO_USER"
else
  # If not run via sudo, try to detect the logged-in user
  REAL_USER=$(logname)
fi

REAL_HOME=$(eval echo "~$REAL_USER")

# System updates
apt update && apt -y upgrade

# Hardware configuration
echo "Configure setup to make it interact with attached hardware. Enable SPI for EPD displays"
sleep 5
raspi-config

# Python setup
apt install -y python3
sudo -u "$REAL_USER" python3 -m venv --system-site-packages "$REAL_HOME/env"

# Startup directories
sudo -u "$REAL_USER" mkdir -p "$REAL_HOME/base-boot"
sudo -u "$REAL_USER" cp -r "$REAL_HOME/rpi-02w-setup/base-boot" "$REAL_HOME/base-boot/"

# Cron setup
echo "__________________Crontab content, you have 10 seconds to copy the content below this line______________________"
cat "$REAL_HOME/rpi-02w-setup/root"
sleep 10
echo "__________________Paste this into the window that appears next______________________"
crontab -e
sleep 5

# Tailscale setup
curl -fsSL https://tailscale.com/install.sh | sh
tailscale set --operator="$REAL_USER"
read -p "Enter your Tailscale auth key: " AUTH_KEY
tailscale up -ssh --authkey "$AUTH_KEY"

# Zsh + Oh My Zsh
apt install -y zsh
sudo -u "$REAL_USER" sh -c 'RUNZSH=no CHSH=no wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O - | sh'

# Zsh plugins
sudo -u "$REAL_USER" mkdir -p "$REAL_HOME/.zsh/plugins"
sudo -u "$REAL_USER" git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$REAL_HOME/.zsh/plugins/zsh-syntax-highlighting"
sudo -u "$REAL_USER" git clone https://github.com/zsh-users/zsh-autosuggestions.git "$REAL_HOME/.zsh/plugins/zsh-autosuggestions"

# Zsh config
sudo -u "$REAL_USER" bash -c "cat >> '$REAL_HOME/.zshrc'" <<'EOF'

# Load zsh plugins
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
alias rcedit='nano ~/.zshrc'
alias refsh='source ~/.zshrc'
source ~/env/bin/activate
EOF

# Set default shell to zsh
chsh -s "$(which zsh)" "$REAL_USER"

apt -y autoremove

echo "✅ All done! Reboot the system to apply changes with: sudo reboot now"
