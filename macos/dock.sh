#!/bin/bash
#
# Configure Dock apps and order.
# Requires: dockutil (brew install dockutil)
#
# Finder is always pinned to the far left.
# Trash is always pinned to the far right.
# Everything in between is configured here.
#
# The active profile's dock.sh (profiles/<name>/dock.sh), if present, is sourced
# after DOCK_APPS is defined and may set EXTRA_DOCK_APPS, which is appended
# to DOCK_APPS (same format, "SPACER" supported).

set -e

if ! command -v dockutil &> /dev/null; then
    echo "  dockutil not found. Install it with: brew install dockutil"
    exit 1
fi

echo "Configuring Dock apps..."

# Clear all current Dock items
dockutil --remove all --no-restart

# Current Xcode ships DeviceHub (Contents/Applications); older Xcode ships Simulator.
XCODE_APP="/Applications/Xcode.app"
XCODE_DEVICE_APP="$XCODE_APP/Contents/Applications/DeviceHub.app"
if [ ! -e "$XCODE_DEVICE_APP" ]; then
    XCODE_DEVICE_APP="$XCODE_APP/Contents/Developer/Applications/Simulator.app"
fi

# Define Dock apps in order.
# "SPACER" inserts a spacer tile.
DOCK_APPS=(
    "/System/Applications/Calendar.app"
    "/System/Applications/System Settings.app"
    "SPACER"
    "/Applications/Safari.app"
    "SPACER"
    "/Applications/Sourcetree.app"
    "$XCODE_APP"
    "$XCODE_DEVICE_APP"
    "/Applications/Sublime Text.app"
    "/Applications/RapidAPI.app"
    "SPACER"
    "/Applications/Slack.app"
    "SPACER"
)

# Profile layer (optional)
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/code/dotfiles}"
PROFILE="${DOTFILES_PROFILE:-$(cat "$HOME/.dotfiles-profile" 2> /dev/null || echo personal)}"
EXTRA_DOCK_APPS=()
if [ -f "$DOTFILES_DIR/profiles/$PROFILE/dock.sh" ]; then
    # shellcheck source=/dev/null
    source "$DOTFILES_DIR/profiles/$PROFILE/dock.sh"
    DOCK_APPS+=("${EXTRA_DOCK_APPS[@]}")
fi

for app in "${DOCK_APPS[@]}"; do
    if [ "$app" = "SPACER" ]; then
        dockutil --add '' --type spacer --section apps --no-restart
    elif [ -e "$app" ]; then
        dockutil --add "$app" --no-restart
    else
        echo "  [warn] Not found, skipping: $app"
    fi
done

# Restart Dock to apply
killall "Dock" &> /dev/null || true

echo "Dock apps configured."
