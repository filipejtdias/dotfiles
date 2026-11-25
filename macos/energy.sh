#!/bin/bash
#
# Energy & power management settings — requires sudo.

set -e

echo "Applying energy settings (requires sudo)..."

# Enable lid wakeup
sudo pmset -a lidwake 1

# Display sleep: 15 min on charger, 2 min on battery
sudo pmset -c displaysleep 15
sudo pmset -b displaysleep 2

# Machine sleep: never on charger, 5 min on battery
# (battery displaysleep must be lower than sleep)
sudo pmset -c sleep 0
sudo pmset -b sleep 5

# Set standby delay to 24 hours
# Apple Silicon uses standbydelayhigh/low instead of standbydelay
if [ "$(uname -m)" = "arm64" ]; then
    sudo pmset -a standbydelayhigh 86400
    sudo pmset -a standbydelaylow 86400
else
    sudo pmset -a standbydelay 86400
fi

# Hibernation mode
sudo pmset -a hibernatemode 3

# Energy mode: 0 = Low Power, 1 = Automatic, 2 = High Performance
# Set battery and charger separately to Automatic
sudo pmset -b powermode 1
sudo pmset -c powermode 1

# Require password immediately after sleep or screen saver
# On modern macOS, sysadminctl controls the system-level lock delay
# (the per-user com.apple.screensaver askForPasswordDelay is no longer enforced)
# Must run as current user (not sudo); pipe empty string for -password -
sysadminctl -screenLock immediate -password - 2>/dev/null <<< "" || true
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo "Energy settings applied."
