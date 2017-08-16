FROM ruby:2.4.1
RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends \
    apt-utils \
    build-essential \
    libpq-dev \
    nodejs \
    libgmp3-dev \
  && apt-get -q clean \
  && rm -rf /var/lib/apt/lists

RUN mkdir /usr/src/trip_tippa

WORKDIR /usr/src/trip_tippa

COPY Gemfile* ./
RUN bundle install

COPY . .

EXPOSE 3000
CMD script/start
