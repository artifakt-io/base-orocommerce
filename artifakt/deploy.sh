#!/bin/sh

 if [[ ! -z $AUTO_SETUP_DOMAIN ]]; then
    if [[ $ARTIFAKT_IS_MAIN_INSTANCE -eq 1 ]]; then
        echo "Removing tables"
        mysql -u $ARTIFAKT_MYSQL_USER -h $ARTIFAKT_MYSQL_HOST $ARTIFAKT_MYSQL_DATABASE_NAME -p$MYSQL_PASSWORD < artifakt/clearTables.sql

        sed -i "s/installed: true/installed: false/g" config/parameters.yml
        echo "Removing cache folder"
        sudo rm -rf var/cache

        
        echo "Starting installation with login: admin@example.com, password artifakt123 and domain $AUTO_SETUP_DOMAIN"
        php bin/console oro:install \
        --env=prod \
        --timeout=600 \
        --language=en \
        --formatting-code="en_US" \
        --user-name="admin" \
        --user-email="admin@example.com" \
        --user-firstname="John" \
        --user-lastname="Doe" \
        --user-password="artifakt123" \
        --application-url="$AUTO_SETUP_DOMAIN" \
        --organization-name="Artifakt" \
        --drop-database \
        --sample-data=y
        
        sudo rm /mnt/shared/auto_setup

        sudo service supervisord restart
    else
        echo "Waiting 30 seconds waiting if the setup script is running"
        sleep 30
        continue=1
        while [ $continue -eq 1 ]
        do
            if [[ -f "/mnt/shared/auto_setup" ]]; then
                echo "/mnt/shared/auto_setup exists, waiting for setup to be finished"
                sleep 5
            else
                echo "File auto_setup doesn't exists, starting commands"
                continue=0
            fi
        done

        . artifakt/orocommands.sh
    fi
else
    echo "To start auto setup please add an environment variable AUTO_SETUP_DOMAIN with the full domain url (with a slash at the end)"
    . artifakt/orocommands.sh
fi
