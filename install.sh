#!/bin/bash
LOG_FILE="install.log"
FIREWALLA_CONFIG_SCRIPT_DIR="/home/pi/.firewalla/config/post_main.d"
APCUPSD_CONFIG_SCRIPT="firewalla-apcupsd.sh"

echo `date` > $LOG_FILE

if [ ! -d "$FIREWALLA_CONFIG_SCRIPT_DIR" ]; then
  echo "Firewalla configuration post_main.d directory does not exist... creating." >> $LOG_FILE
  mkdir -p $FIREWALLA_CONFIG_SCRIPT_DIR
fi

if [[ -f "$FIREWALLA_CONFIG_SCRIPT_DIR/$APCUPSD_CONFIG_SCRIPT" ]]; then
  echo "Firewalla APC UPS Daemon script already installed. Exiting." >> $LOG_FILE
  exit 0
fi

echo "Copying script to persistent configuration script location..." >> $LOG_FILE
cp $APCUPSD_CONFIG_SCRIPT "$FIREWALLA_CONFIG_SCRIPT_DIR/$APCUPSD_CONFIG_SCRIPT"

echo "Done" >> $LOG_FILE

echo "Firewalla Config Script Directory contents: " >> $LOG_FILE
ls -la $FIREWALLA_CONFIG_SCRIPT_DIR >> $LOG_FILE

exit
