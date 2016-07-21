#!/bin/bash
set -e

rm -rf tmp/

if [ "$DB_ENV_AUTO_MIGRATE" == "yes" ]; then
  bin/rake db:schema:load RAILS_ENV=development
fi

if [ "$TESTDB_ENV_AUTO_MIGRATE" == "yes" ]; then
  bin/rake db:schema:load RAILS_ENV=test
fi

bin/rake assets:precompile

# host ip needed by application for better_errors whitelisting to work
export HOST_IP=`/sbin/ip route|awk '/default/ { print $3 }'`

exec "$@"
