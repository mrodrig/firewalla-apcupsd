#!/bin/bash
LOG_FILE="/var/log/firewalla-apcupsd.log"
PRESENCE_CHECK_FILE="/etc/init.d/apcupsd"

echo `date` > $LOG_FILE

if [[ -f "$PRESENCE_CHECK_FILE" ]]; then
  echo "APCUPSD already installed, exiting..." >> $LOG_FILE
  exit 0
fi

echo "APCUPSD not yet configured, installing..." >> $LOG_FILE

# Otherwise, we need to install apcupsd again...
# Install just the apcupsd package without any recommended packages
sudo /usr/bin/apt-get install apcupsd -y --no-install-recommends

# Stop the process and remove the default PID file
sudo /etc/init.d/apcupsd stop
sudo rm -rf /var/run/apcupsd.pid

# Switch IS_CONFIGURED=no to IS_CONFIGURED=yes
sudo sed -i .bak 's/no/yes/' /etc/default/apcupsd
echo "Configured /etc/default/apcupsd to IS_CONFIGURED=yes" >> $LOG_FILE

# Swap our configuration file into place
sudo cp /etc/apcupsd/apcupsd.conf /etc/apcupsd/apcupsd.conf.original
sudo echo "UPSNAME fwgups1" > /etc/apcupsd/apcupsd.conf
sudo echo "UPSCABLE usb" >> /etc/apcupsd/apcupsd.conf
sudo echo "UPSTYPE usb" >> /etc/apcupsd/apcupsd.conf
sudo echo "DEVICE" >> /etc/apcupsd/apcupsd.conf
sudo echo "LOCKFILE /tmp" >> /etc/apcupsd/apcupsd.conf
sudo echo "SCRIPTDIR /etc/apcupsd" >> /etc/apcupsd/apcupsd.conf
sudo echo "PWRFAILDIR /etc/apcupsd" >> /etc/apcupsd/apcupsd.conf
sudo echo "NOLOGINDIR /etc" >> /etc/apcupsd/apcupsd.conf
sudo echo "ONBATTERYDELAY 6" >> /etc/apcupsd/apcupsd.conf
sudo echo "BATTERYLEVEL 5" >> /etc/apcupsd/apcupsd.conf
sudo echo "MINUTES 10" >> /etc/apcupsd/apcupsd.conf
sudo echo "TIMEOUT 0" >> /etc/apcupsd/apcupsd.conf
sudo echo "ANNOY 300" >> /etc/apcupsd/apcupsd.conf
sudo echo "ANNOYDELAY 60" >> /etc/apcupsd/apcupsd.conf
sudo echo "NOLOGON disable" >> /etc/apcupsd/apcupsd.conf
sudo echo "KILLDELAY 0" >> /etc/apcupsd/apcupsd.conf
sudo echo "NETSERVER on" >> /etc/apcupsd/apcupsd.conf
sudo echo "NISIP 127.0.0.1" >> /etc/apcupsd/apcupsd.conf
sudo echo "NISPORT 3551" >> /etc/apcupsd/apcupsd.conf
sudo echo "EVENTSFILE /var/log/apcupsd.events" >> /etc/apcupsd/apcupsd.conf
sudo echo "EVENTSFILEMAX 10" >> /etc/apcupsd/apcupsd.conf
sudo echo "UPSCLASS standalone" >> /etc/apcupsd/apcupsd.conf
sudo echo "UPSMODE disable" >> /etc/apcupsd/apcupsd.conf
sudo echo "STATTIME 0" >> /etc/apcupsd/apcupsd.conf
sudo echo "STATFILE /var/log/apcupsd.status" >> /etc/apcupsd/apcupsd.conf
sudo echo "LOGSTATS off" >> /etc/apcupsd/apcupsd.conf
sudo echo "DATATIME 0" > /etc/apcupsd/apcupsd.conf

sudo echo "Configured apcupsd.conf file" >> $LOG_FILE
sudo echo "Configuration file contents:" >> $LOG_FILE
sudo cat /etc/apcupsd/apcupsd.conf >> $LOG_FILE

# Restart process:
sudo /etc/init.d/apcupsd start
sudo echo "Started apcupsd" >> $LOG_FILE

# Get status from 'apcaccess status'
sudo echo "UPS Status:" >> $LOG_FILE
sudo apcaccess status >> $LOG_FILE
