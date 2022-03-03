FROM ruby:2.4.10-buster

# https://github.com/Yelp/dumb-init
RUN wget --quiet https://github.com/Yelp/dumb-init/releases/download/v1.0.1/dumb-init_1.0.1_amd64.deb
RUN dpkg -i dumb-init_*.deb

# Inspired by https://blog.codeship.com/running-rails-development-environment-docker/
RUN apt-get update && apt-get install -y build-essential nodejs libpq-dev git unzip libgeos-dev proj-bin libproj-dev make less build-essential patch vim sendmail

COPY . /code
WORKDIR /code

RUN git log -n 1 --pretty=format:"%H" > /version

RUN addgroup appuser && adduser --disabled-password appuser --ingroup appuser --gecos ""
RUN mkdir -p /code/tmp && chown appuser:appuser /code/tmp
RUN mkdir -p /code/log && chown appuser:appuser /code/log

# Temporarily fix wrong let's encrypt R3 chain because it's chained to an expired old root CA (DST Root CA X3) on debian 9
# https://stackoverflow.com/questions/69438081/expired-ca-certificates-in-ruby-docker-image-2-6-8-bullseye
RUN sed -i -E 's/(.*DST_Root_CA_X3.*)/!\1/' /etc/ca-certificates.conf
RUN update-ca-certificates

RUN gem update --system 3.3.8

RUN gem install bundler -v 1.17.3

# Line below is to try to solve nokogiri build failure
RUN bundle  config build.nokogiri --use-system-libraries

RUN bundle  install

USER appuser

EXPOSE 3000

ENV RAILS_ENV=production
ENV IEV_DISABLE_CACHE=true
CMD [ "dumb-init", "bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
