#!/bin/sh

if [[ ! -z $AUTO_SETUP_DOMAIN ]]; then
    if [[ $ARTIFAKT_IS_MAIN_INSTANCE -eq 1 ]]; then
        sudo touch /mnt/shared/auto_setup
    fi
else
    if [[ -f "/mnt/shared/auto_setup" ]]; then
        sudo rm /mnt/shared/auto_setup
    fi
fi