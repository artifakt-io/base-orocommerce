#!/bin/sh

if [[ ! -z $AUTO_SETUP_DOMAIN ]]; then
    if [[ $ARTIFAKT_IS_MAIN_INSTANCE -eq 1 ]]; then
        sudo echo "1" >> /mnt/shared/auto_setup
    fi
else
    sudo rm /mnt/shared/auto_setup
fi