FROM ruby:3.3-slim

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
    shared-mime-info \
    nodejs \
    npm

COPY package.json package-lock.json ./
RUN npm install

ADD Gemfile* ./

RUN gem install bundler && bundle install

ADD bin/ ./bin
ADD config/ ./config
ADD config.ru ./
ADD Rakefile ./
ADD db/ ./db
ADD lib/ ./lib
ADD public/ ./public
ADD app/ ./app
ADD features/ ./features
ADD script/ ./script
ADD spec/ ./spec
ADD vendor/ ./vendor
ADD docker/ ./docker
ADD .rubocop.yml ./.rubocop.yml
ADD .sass-lint.yml ./.sass-lint.yml

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
