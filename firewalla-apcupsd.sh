#!/bin/bash
LOG_FILE="/tmp/firewalla-apcupsd.log"
PRESENCE_CHECK_FILE="/etc/init.d/apcupsd"
APCUPSD_CONFIG_FILE="apcupsd.conf"

sudo echo `date` > $LOG_FILE

if [[ -f "$PRESENCE_CHECK_FILE" ]]; then
  sudo echo "APCUPSD already installed, exiting..." >> $LOG_FILE
  exit 0
fi

sudo echo "APCUPSD not yet configured, installing..." >> $LOG_FILE

# Otherwise, we need to install apcupsd again...
# Install just the apcupsd package without any recommended packages
sudo /usr/bin/apt-get install apcupsd -y --no-install-recommends

# Stop the process and remove the default PID file
sudo /etc/init.d/apcupsd stop
sudo rm -rf /var/run/apcupsd.pid

# Switch IS_CONFIGURED=no to IS_CONFIGURED=yes
sudo sed -i'.bak' s/no/yes/ /etc/default/apcupsd
sudo echo "Configured /etc/default/apcupsd to IS_CONFIGURED=yes" >> $LOG_FILE

# Swap our configuration file into place
sudo cp /etc/apcupsd/apcupsd.conf /etc/apcupsd/apcupsd.conf.original
sudo cp $APCUPSD_CONFIG_FILE /etc/apcupsd/apcupsd.conf

sudo echo "Configured apcupsd.conf file" >> $LOG_FILE
sudo echo "Configuration file contents:" >> $LOG_FILE
sudo cat /etc/apcupsd/apcupsd.conf >> $LOG_FILE

# Restart process:
sudo /etc/init.d/apcupsd start
sudo echo "Started apcupsd" >> $LOG_FILE

# Get status from 'apcaccess status'
sudo echo "UPS Status:" >> $LOG_FILE
sudo apcaccess status >> $LOG_FILE
