#!/bin/bash
set -e

if [ "$DB_AUTO_MIGRATE" == "true" ]; then
  bin/rake db:migrate
fi

if [ "$TEST_DB_AUTO_MIGRATE" == "true" ]; then
  bin/rake db:migrate RAILS_ENV=test
fi

# host ip needed by application for better_errors whitelisting to work
export HOST_IP=`/sbin/ip route|awk '/default/ { print $3 }'`

printenv | sed "s/^\([[:alnum:]_]*\)=\(.*\)$/export \1='\2'/" >/var/www/.profile

exec "$@"
