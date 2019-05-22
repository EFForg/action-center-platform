FROM ruby:2.5

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
    libssl1.0-dev

RUN set -x; \
  curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh \
  && chmod +x nodesource_setup.sh \
  && ./nodesource_setup.sh \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    nodejs \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install \
    yarn

# Create a symlink to what will be the phantomjs exec path
RUN ln -s /phantomjs-2.1.1-linux-x86_64/bin/phantomjs /bin/phantomjs

# Set up phantomjs, making sure to check the known good sha256sum
RUN cd / && curl -sLo phantomjs.tar.bz2 https://github.com/Medium/phantomjs/releases/download/v2.1.1/phantomjs-2.1.1-linux-x86_64.tar.bz2 && \
  bash -l -c '[ "`sha256sum phantomjs.tar.bz2 | cut -f1 -d" "`" = "86dd9a4bf4aee45f1a84c9f61cf1947c1d6dce9b9e8d2a907105da7852460d2f" ]' && \
  tar -jxvf phantomjs.tar.bz2 > /dev/null && \
  rm phantomjs.tar.bz2

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
CMD ["rails", "s", "-b", "0.0.0.0"]
ENTRYPOINT ["/opt/actioncenter/docker/entrypoint.sh"]
