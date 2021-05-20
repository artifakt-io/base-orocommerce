#!/bin/sh

if [[ $AUTO_SETUP -eq 1 ]]; then
 if [[ -z $AUTO_SETUP_DOMAIN ]]; then

    # Delete all tables
    
        php bin/console oro:install \
        --env=prod \
        --timeout=600 \
        --language=en \
        --formatting-code="en_US" \
        --user-name="admin" \
        --user-email="admin@example.com" \
        --user-firstname="John" \
        --user-lastname="Doe" \
        --user-password="PleaseReplaceWithSomeStrongPassword" \
        --application-url="$AUTO_SETUP_DOMAIN"
    else
    echo "To start auto setup please add an environment variable AUTO_SETUP_DOMAIN with the full domain url (with a slash at the end)"
 fi
fi