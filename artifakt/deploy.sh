#!/bin/sh

 if [[ ! -z $AUTO_SETUP_DOMAIN ]]; then
    if [[ $ARTIFAKT_IS_MAIN_INSTANCE -eq 1 ]]; then

        echo "Removing tables"
        mysql -u $ARTIFAKT_MYSQL_USER -h $ARTIFAKT_MYSQL_HOST $ARTIFAKT_MYSQL_DATABASE_NAME -p$MYSQL_PASSWORD < artifakt/clearTables.sql

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
        --application-url="$AUTO_SETUP_DOMAIN" \
        --organization-name="Artifakt" \
        --sample-data=y

        sudo service supervisord restart
    fi
else
    echo "To start auto setup please add an environment variable AUTO_SETUP_DOMAIN with the full domain url (with a slash at the end)"
    
fi

php bin/console oro:cron:message-queue:cleanup
php bin/console oro:cron:message-queue:consumer_heartbeat_check
php bin/console oro:cron:email-body-sync
php bin/console oro:cron:integration:cleanup
php bin/console oro:cron:integration:sync
php bin/console oro:cron:import-clean-up-storage
php bin/console oro:cron:api:async_operations:cleanup
php bin/console oro:cron:batch:cleanup
php bin/console oro:cron:imap-sync
php bin/console oro:cron:imap-credential-notifications
php bin/console oro:cron:calendar:date
php bin/console oro:cron:product-collections:index
php bin/console oro:cron:import-tracking
php bin/console oro:cron:tracking:parse
php bin/console oro:cron:calculate-tracking-event-summary
php bin/console oro:cron:send-email-campaigns
php bin/console oro:cron:lifetime-average:aggregate
php bin/console oro:cron:send-reminders
php bin/console oro:cron:analytic:calculate
php bin/console oro:cron:price-lists:schedule
php bin/console oro:cron:shopping-list:clear-expired
php bin/console oro:cron:customer-visitors:clear-expired
php bin/console oro:cron:sitemap:generate
php bin/console oro:cron:dotmailer:export-status:update
php bin/console oro:cron:dotmailer:force-fields-sync
php bin/console oro:cron:dotmailer:mapped-fields-updates:process
php bin/console oro:cron:oauth-server:cleanup

php bin/console oro:translation:load

php bin/console oro:search:reindex

php bin/console oro:website-search:reindex

php bin/console oro:assets:install