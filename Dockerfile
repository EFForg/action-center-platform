FROM rails:4.2.6

RUN mkdir /opt/actioncenter
WORKDIR /opt/actioncenter

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    libpq-dev \
    libqt4-dev \
    libqtwebkit-dev \
    xvfb \
    xauth && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

ADD Gemfile* ./

RUN bundle install

ADD bin/ ./bin
ADD config/ ./config
ADD config.ru ./
ADD Rakefile ./
ADD Procfile ./
ADD db/ ./db
ADD lib/ ./lib
ADD public/ ./public
ADD app/ ./app
ADD features/ ./features
ADD script/ ./script
ADD spec/ ./spec
ADD vendor/ ./vendor
ADD docker/ ./docker

RUN bundle exec rake assets:precompile --silent \
  RAILS_ENV=production \
  SECRET_KEY_BASE=noop \
  devise_secret_key=noop \
  DATABASE_URL=postgres://noop \
  2>&1 | grep -v INFO
RUN bundle exec rake webshims:update_public

CMD ["rails", "s", "-b", "0.0.0.0"]
ENTRYPOINT ["/opt/actioncenter/docker/entrypoint.sh"]
