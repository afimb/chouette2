FROM ruby:2.3.1

# https://github.com/Yelp/dumb-init
RUN wget --quiet https://github.com/Yelp/dumb-init/releases/download/v1.0.1/dumb-init_1.0.1_amd64.deb
RUN dpkg -i dumb-init_*.deb

# Inspired by https://blog.codeship.com/running-rails-development-environment-docker/
RUN apt-get update && apt-get install -y \
  build-essential \
  nodejs

RUN apt-get install -y libpq-dev git unzip libgeos-dev proj-bin libproj-dev make

RUN apt-get install -y less build-essential patch vim sendmail

RUN gem install bundler -v 1.13.5

COPY . /code
WORKDIR /code

RUN git log -n 1 --pretty=format:"%H" > /version

# Line below is to try to solve nokogiri build failure
RUN bundle config build.nokogiri --use-system-libraries

RUN bundle install

EXPOSE 3000

ENV RAILS_ENV=production
ENV IEV_DISABLE_CACHE=true
CMD [ "dumb-init", "bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
