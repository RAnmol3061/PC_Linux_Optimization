#!/bin/bash

LOG_FILE="battery_trends.csv"
INTERVAL=10

# Header
if [ ! -f "$LOG_FILE" ]; then
    echo "Date,Time,State,Energy_Rate_W,Full_Energy_W,Full_Energy_Design_W,Percentage" > "$LOG_FILE"
fi

echo "--- Logging Started: $(date) ---"

cleanup() {
    echo -e "\n--- Logging Stopped ---"
    exit 0
}

trap cleanup SIGINT SIGTERM

while true; do
    CURRENT_DATE=$(date +%Y-%m-%d)
    CURRENT_TIME=$(date +%H:%M:%S)

    # HARDENED EXTRACTION:
    # 1. We search for the label followed by a colon (e.g., "state:")
    # 2. 'head -n 1' ensures only ONE line is captured, even if there are duplicates
    STATE=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep "state:" | head -n 1 | awk '{print $2}')
    RATE=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep "energy-rate:" | head -n 1 | awk '{print $2}')
    ENERGY_FULL=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -w "energy-full:" | head -n 1 | awk '{print $2}')
    ENERGY_FULLD=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep "energy-full-design:" | head -n 1 | awk '{print $2}') 
    PERCENTAGE=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep "percentage:" | head -n 1 | awk '{print $2}' | tr -d '%')

    # Logging with validation
    if [[ ! -z "$STATE" && ! -z "$RATE" && ! -z "$PERCENTAGE" ]]; then
        echo "$CURRENT_DATE,$CURRENT_TIME,$STATE,$RATE,$ENERGY_FULL,$ENERGY_FULLD,$PERCENTAGE" >> "$LOG_FILE"
    fi

    sleep "$INTERVAL"
done

-----------------------------------------------------

This is the bash code for the script

-----------------------------------------


step1: create a folder inside .config/systemd/user
step2: Create a file called (battery-logger.service)
step3: Paste these inside:

[Unit]
Description=Battery Trends Logging Service
After=network.target

[Service]
ExecStart=//home/user/Documents/battery-log.sh
Restart=always
RestartSec=10

[Install]
WantedBy=default.target


step4:systemctl --user daemon-reload
systemctl --user enable battery-logger.service
systemctl --user start battery-logger.service

output file is in home directory