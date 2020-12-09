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
# SSH into your Firewalla Gold
ssh pi@<network_gateway_ip>
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

## Contributing

Since everyone's configuration is different, I'm open to pull requests that
improve the script logic and performance, but will likely not merge any PRs
which seek to adjust the configuration specified in this project, unless it is
in response to an `apcupsd` package update on the Firewalla Gold unit.
