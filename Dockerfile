FROM rails:4.2

RUN mkdir /opt/actioncenter
WORKDIR /opt/actioncenter

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    libpq-dev \
    libqt4-dev \
    libqtwebkit-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

ADD Gemfile .

RUN bundle install

ADD bin/ ./bin
ADD config/ ./config
ADD config.ru .
ADD Rakefile .
ADD Procfile .
ADD db/ ./db
ADD lib/ ./lib
ADD public/ ./public
ADD app/ ./app
ADD features/ ./features
ADD script/ ./script
ADD spec/ ./spec
ADD vendor/ ./vendor
ADD docker/ ./docker

CMD ["rails", "s", "-b", "0.0.0.0"]
ENTRYPOINT ["/opt/actioncenter/docker/entrypoint.sh"]
