#!/bin/bash
set -e

bin/rake db:migrate RAILS_ENV=development

exec "$@"
