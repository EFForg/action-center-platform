FROM ruby:2.5-stretch

RUN mkdir /opt/actioncenter
WORKDIR /opt/actioncenter

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
    libssl-dev

RUN set -x; \
  curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh \
  && chmod +x nodesource_setup.sh \
  && ./nodesource_setup.sh \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    nodejs \
    npm \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install \
    yarn

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
  DATABASE_URL=postgres://noop
RUN bundle exec rake webshims:update_public

RUN mkdir /opt/actioncenter/log \
          /var/www
RUN chown -R www-data /opt/actioncenter/public \
                      /opt/actioncenter/db \
                      /opt/actioncenter/tmp \
                      /opt/actioncenter/log \
                      /var/www

USER www-data
CMD ["bin/rails", "s", "-b", "0.0.0.0"]
ENTRYPOINT ["/opt/actioncenter/docker/entrypoint.sh"]
