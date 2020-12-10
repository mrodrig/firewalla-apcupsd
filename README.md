# firewalla-apcupsd

## What is this project?

This project is intended to provide a customized script that's compatible with
Firewalla Gold units that allows you to easily integrate an APC UPS device for
battery backup and surge protection in the event of a less than ideal power
situation.

Note that this project is not officially supported by either Firewalla or APC
and is provided free of charge as open source software. Firewalla, APC, and the
contributors of this package provide no guarantees of compatibility or any other
warranty if you choose to use this software on your Firewalla Gold unit.

## Installation

```bash
# SSH into your Firewalla Gold (specify your network gateway IP)
# Note: Please verify that SSH is enabled for your particular network
ssh pi@192.168.100.1 # eg. for a 192.168.100.1/24 network
# Enter password from Firewalla app --> Settings --> Advanced --> Configurations --> SSH Console --> Tap password to reveal

# Clone the repository on your Firewalla Gold
git clone https://github.com/mrodrig/firewalla-apcupsd.git

# Navigate into the cloned directory and ensure the scripts are executable
cd firewalla-apcupsd
chmod +x *.sh

# Install the firewalla-apcupsd.conf script into the Firewalla custom scripts directory
./install.sh

# Run the installation script to ensure APCUPSD is installed.
./firewalla-apcupsd.sh

# Done!
```

## How does this work?

This script leverages Firewalla's [Customized Scripting](https://help.firewalla.com/hc/en-us/articles/360054056754--Firewalla-Gold-Customized-Scripting-)
functionality to provide a persistent UPS package installation and configuration
on your Firewalla Gold unit. This package will use a default configuration, as
specified in the `firewalla-apcupsd.sh` script so you may need to customize it
before running `install.sh` depending on your specific UPS. The settings that
were specified were for the Back-UPS 1000VA 600W unit that I purchased
(Model Number: BX1000M-LM60) for use with my network equipment.

Essentially the `install.sh` script will copy the `firewalla-apcupsd.sh` script
and the `apcupsd.conf` configuration file over to
`/home/pi/.firewalla/config/post_main.d` where Firewalla allows custom scripts
to be stored so that whenever your Firewalla Gold is restarted or updated your
Firewalla Gold will not lose your APC UPS configuration or connection. Without
this custom script and configuration, your Firewalla Gold effectively uninstalls
the `apcupsd` package that's required to integrate with an APC UPS system at
every reboot, causing the UPS to simply run until the battery is completely
depleted, and therefore decreasing the life of the UPS' battery.

Currently this project does not support running custom scripts when different
power events are reported by the UPS, but I am open to pull requests to add
support for that functionality and good documentation around the configuration
and usage of the feature.

## Contributing

Since everyone's configuration is different, I'm open to pull requests that
improve the script logic, performance, and reliability, but will likely not
merge any PRs seek to adjust the configuration specified in this project, unless
it is in response to an `apcupsd` package update on the Firewalla Gold unit.
