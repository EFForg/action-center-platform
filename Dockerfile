FROM ruby:2.3.1

RUN mkdir /opt/actioncenter
WORKDIR /opt/actioncenter

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    libpq-dev \
    nodejs \
    postgresql-client \
    cron && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*


# Create a symlink to what will be the phantomjs exec path
RUN ln -s /phantomjs-2.1.1-linux-x86_64/bin/phantomjs /bin/phantomjs

# Set up phantomjs, making sure to check the known good sha256sum
RUN cd / && curl -sLo phantomjs.tar.bz2 https://github.com/Medium/phantomjs/releases/download/v2.1.1/phantomjs-2.1.1-linux-x86_64.tar.bz2 && \
  bash -l -c '[ "`sha256sum phantomjs.tar.bz2 | cut -f1 -d" "`" = "86dd9a4bf4aee45f1a84c9f61cf1947c1d6dce9b9e8d2a907105da7852460d2f" ]' && \
  tar -jxvf phantomjs.tar.bz2 > /dev/null && \
  rm phantomjs.tar.bz2


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

COPY docker/crontab /etc/cron.d/crontab
RUN chmod 0644 /etc/cron.d/crontab
RUN touch /var/log/cron.log
RUN chown www-data /etc/cron.d/crontab \
                   /var/log/cron.log

RUN mkdir /opt/actioncenter/tmp && \
    chown -R www-data /opt/actioncenter/public \
                      /opt/actioncenter/tmp

RUN chmod o+w /usr/local/bundle/config

USER www-data

CMD ["rails", "s", "-b", "0.0.0.0"]
ENTRYPOINT ["/opt/actioncenter/docker/entrypoint.sh"]
