FROM ruby:3.3-bullseye

RUN mkdir /opt/actioncenter
WORKDIR /opt/actioncenter

COPY db/global-bundle.pem /opt/actioncenter/vendor/assets/certificates/

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    curl \
    build-essential \
    git \
    libpq-dev \
    libfontconfig \
    postgresql-client \
    cron \
    gnupg \
    libssl-dev \
    libffi-dev \
    shared-mime-info \
    nodejs \
    npm

COPY package.json package-lock.json ./
RUN npm install

COPY Gemfile* ./

RUN gem install bundler && bundle install --deployment

COPY bin/ ./bin
COPY config/ ./config
COPY config.ru ./
COPY Rakefile ./
COPY db/ ./db
COPY lib/ ./lib
COPY public/ ./public
COPY app/ ./app
COPY features/ ./features
COPY script/ ./script
COPY spec/ ./spec
COPY vendor/ ./vendor
COPY docker/ ./docker
COPY .rubocop.yml ./.rubocop.yml
COPY .sass-lint.yml ./.sass-lint.yml

RUN usermod -u 1000 www-data

COPY docker/crontab /etc/cron.d/crontab
RUN chmod 0644 /etc/cron.d/crontab

RUN bundle exec rake assets:precompile \
  RAILS_ENV=production \
  SECRET_KEY_BASE=noop \
  devise_secret_key=noop \
  amazon_region=noop \
  amazon_bucket=noop \
  DATABASE_URL=postgres://noop

RUN mkdir /var/www
RUN chown -R www-data /opt/actioncenter/public \
                      /opt/actioncenter/db \
                      /opt/actioncenter/tmp \
                      /opt/actioncenter/log \
                      /var/www

USER www-data
CMD ["bin/rails", "s", "-b", "0.0.0.0"]
ENTRYPOINT ["/opt/actioncenter/docker/entrypoint.sh"]
