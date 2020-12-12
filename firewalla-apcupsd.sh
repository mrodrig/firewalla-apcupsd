#!/bin/bash
LOG_FILE="/tmp/firewalla-apcupsd.log"
APCUPSD_CONFIG_FILE="/home/pi/.firewalla/config/post_main.d/apcupsd.conf"
APCUPSD_DEFAULT_FILE="/etc/default/apcupsd"
PRESENCE_CHECK_FILE="/etc/init.d/apcupsd"
APCUPSD_TARGET_FILE="/etc/apcupsd/apcupsd.conf"

sudo echo `date` &> $LOG_FILE

if [[ -f "$PRESENCE_CHECK_FILE" ]]; then
  sudo echo "APCUPSD already installed, exiting..." &>> $LOG_FILE
  exit 0
fi

sudo echo "APCUPSD not yet configured, installing..." &>> $LOG_FILE

# Otherwise, we need to install apcupsd again...
# Install just the apcupsd package without any recommended packages
sudo /usr/bin/apt-get install apcupsd -y --no-install-recommends &>> $LOG_FILE

# Stop the process and remove the default PID file
sudo /etc/init.d/apcupsd stop &>> $LOG_FILE
sudo rm -rf /var/run/apcupsd.pid &>> $LOG_FILE

# Switch IS_CONFIGURED=no to IS_CONFIGURED=yes
sudo sed -i'.bak' s/no/yes/ $APCUPSD_DEFAULT_FILE &>> $LOG_FILE
sudo echo "Updated $APCUPSD_DEFAULT_FILE to IS_CONFIGURED=yes" &>> $LOG_FILE

# Swap our configuration file into place
sudo cp $APCUPSD_TARGET_FILE "$APCUPSD_TARGET_FILE.original" &>> $LOG_FILE
sudo cp $APCUPSD_CONFIG_FILE $APCUPSD_TARGET_FILE &>> $LOG_FILE
sudo echo "Configured apcupsd.conf file" &>> $LOG_FILE
sudo echo "Configuration file checksum comparison:" &>> $LOG_FILE
sudo sha1sum $APCUPSD_CONFIG_FILE &>> $LOG_FILE
sudo sha1sum $APCUPSD_TARGET_FILE &>> $LOG_FILE

# Restart process:
sudo /etc/init.d/apcupsd start &>> $LOG_FILE
sudo echo "Started apcupsd" &>> $LOG_FILE

# Get status from 'apcaccess status'
sudo echo "UPS Status:" &>> $LOG_FILE
sudo apcaccess status &>> $LOG_FILE
