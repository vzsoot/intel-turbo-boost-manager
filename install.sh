#!/bin/bash

if [ ! -f /usr/bin/thermal.sh ]; then
    sudo ln -s $(pwd)/thermal.sh /usr/bin/thermal.sh
fi

sudo systemctl enable $(pwd)/thermal.service