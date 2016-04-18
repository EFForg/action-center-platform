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
