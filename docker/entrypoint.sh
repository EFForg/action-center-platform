#!/bin/bash
set -e

rm -rf tmp/
if [ "$DB_ENV_AUTO_MIGRATE" == "yes" ]; then
  bin/rake db:migrate RAILS_ENV=development
fi

exec "$@"
