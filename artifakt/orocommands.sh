#!/bin/sh

composer install
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

php bin/console oro:translation:load --env=prod

php bin/console oro:search:reindex --env=prod

php bin/console oro:website-search:reindex --env=prod

php bin/console oro:assets:install --env=prod