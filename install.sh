#!/bin/bash
LOG_FILE="install.log"
FIREWALLA_CONFIG_SCRIPT_DIR="/home/pi/.firewalla/config/post_main.d"
APCUPSD_CONFIG_SCRIPT="firewalla-apcupsd.sh"
APCUPSD_CONFIG_FILE="apcupsd.conf"

echo `date` &> $LOG_FILE

if [ ! -d "$FIREWALLA_CONFIG_SCRIPT_DIR" ]; then
  echo "Firewalla configuration post_main.d directory does not exist... creating." &>> $LOG_FILE
  mkdir -p $FIREWALLA_CONFIG_SCRIPT_DIR
fi

if [[ -f "$APCUPSD_CONFIG_FILE" ]]; then
  echo "Copying updated configuration file to installation directory." &>> $LOG_FILE

  # Create a backup of the file that's currently in the
  if [[ -f "$FIREWALLA_CONFIG_SCRIPT_DIR/$APCUPSD_CONFIG_FILE" ]]; then
    echo "Moving existing $APCUPSD_CONFIG_FILE file in $FIREWALLA_CONFIG_SCRIPT_DIR aside as .backup" >> $LOG_FILE
    cp "$FIREWALLA_CONFIG_SCRIPT_DIR/$APCUPSD_CONFIG_FILE" "$FIREWALLA_CONFIG_SCRIPT_DIR/$APCUPSD_CONFIG_FILE.backup"
  fi

  cp "$APCUPSD_CONFIG_FILE" "$FIREWALLA_CONFIG_SCRIPT_DIR/$APCUPSD_CONFIG_FILE"
fi

if [[ -f "$FIREWALLA_CONFIG_SCRIPT_DIR/$APCUPSD_CONFIG_SCRIPT" ]]; then
  echo "Firewalla APC UPS Daemon script already installed. Exiting." &>> $LOG_FILE
  exit 0
fi

echo "Copying script to persistent configuration script location..." &>> $LOG_FILE
cp $APCUPSD_CONFIG_SCRIPT "$FIREWALLA_CONFIG_SCRIPT_DIR/$APCUPSD_CONFIG_SCRIPT"

echo "Done" >> $LOG_FILE

echo "Firewalla Config Script Directory contents: " &>> $LOG_FILE
ls -la $FIREWALLA_CONFIG_SCRIPT_DIR &>> $LOG_FILE

exit
