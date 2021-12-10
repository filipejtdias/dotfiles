#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Language & Region\n\n"

execute "defaults write -g AppleMeasurementUnits -string 'Centimeters' && \
		 defaults write NSGlobalDomain AppleMeasurementUnits -string 'Centimeters'" \
    "Set measurement units"

execute "defaults write NSGlobalDomain AppleMetricUnits -bool true" \
	"Set Metrics Units"

execute "defaults write -g AppleTemperatureUnit -string 'Celsius'" \
	"Temperature units" 