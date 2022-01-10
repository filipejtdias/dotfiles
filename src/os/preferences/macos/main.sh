#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Close any open `System Preferences` panes in order to
# avoid overriding the preferences that are being changed.

./close_system_preferences_panes.applescript

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

./activity_monitor.sh
./app_store.sh
./better_snap_tool.sh
./calendar.sh
./chrome.sh
./dock.sh
./energy.sh
./finder.sh
./keyboard.sh
./language_and_region.sh
./magic_mouse.sh
./maps.sh
./menu_bar.sh
./photos.sh
./safari.sh
./screen.sh
./source_tree.sh
./sublime.sh
./terminal.sh
./textedit.sh
./trackpad.sh
./ui_and_ux.sh
./xcode.sh
