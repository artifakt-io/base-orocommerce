#!/bin/sh

if [[ $AUTO_SETUP -eq 1 ]]; then
 if [[ ! -z $AUTO_SETUP_DOMAIN ]]; then
    sed -i "s/installed: true/installed: false/g" config/parameters.yml
    echo "Removing cache folder"
    sudo rm -rf var/cache/*
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
    --application-url="$AUTO_SETUP_DOMAIN"

    sudo service supervisord restart
else
    echo "To start auto setup please add an environment variable AUTO_SETUP_DOMAIN with the full domain url (with a slash at the end)"
 fi
fi