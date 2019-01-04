# intel-turbo-boost-manager
A daemon script to manage IntelTM Turbo-BoostTM to avoid overheat.
Use at your own risk.

# Install
* Secure boot needs to be disabled in BIOS (at your own risk)
* Install msr-tools tools
* Install msr kernel module
* Run the install.sh script

# Notes
* The service and shell script will reference the directory install.sh is located. This directory should be mounted at service start time.
* The service takes sensor heat samples in each second and turns off Turbo-Boost if the temperature is above 90°C. Turns Turbo-Boost back on if the temperature is below 70°C again.
