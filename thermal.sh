#!/bin/bash

if [[ -z $(which rdmsr) ]]; then
    echo "msr-tools is not installed. Run 'sudo apt-get install msr-tools' to install it." >&2
    exit 1
fi

function turbo-boost-ctl() {
    cores=$(cat /proc/cpuinfo | grep processor | awk '{print $3}')
    for core in $cores; do
        if [[ $1 == "disable" ]]; then
	    sudo wrmsr -p${core} 0x1a0 0x4000850089
        fi
	if [[ $1 == "enable" ]]; then
            sudo wrmsr -p${core} 0x1a0 0x850089
	fi
        state=$(sudo rdmsr -p${core} 0x1a0 -f 38:38)
	if [[ $state -eq 1 ]]; then
            echo "core ${core}: disabled"
	else
            echo "core ${core}: enabled"
	fi
    done
}

turbo-boost-ctl enable
state=1
check_counter=1
while true; do
    val=$(sensors | awk '/CPU/ {print $2}')
    max="+90.0"
    min="+70.0"
    if [ "$val" \> "$max" ] && [ $state == 1 ]; then
	echo "Disable turbo-boost at temp: ${val}"
	turbo-boost-ctl disable
	state=0
    fi
    if [ "$val" \< "$min" ] && [ $state == 0 ]; then
	echo "Enable turbo-boost at temp: ${val}"
	turbo-boost-ctl enable
	state=1
    fi

    check_counter=$((check_counter+1))
    if [ $(( $check_counter % 60 )) == 0 ]; then
	echo "CPU sensor temperature value: ${val}"
    fi
    sleep 1
done

exit 0