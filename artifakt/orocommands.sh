#!/bin/sh

composer install
php bin/console oro:translation:load --env=prod

php bin/console oro:search:reindex --env=prod

php bin/console oro:website-search:reindex --env=prod

php bin/console oro:assets:install --env=prod