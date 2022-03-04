FROM ruby:2.6.9-slim-bullseye

RUN apt-get update && apt-get install -y build-essential nodejs libpq-dev git unzip libgeos-dev proj-bin libproj-dev make less patch vim sendmail wget dumb-init shared-mime-info sqlite3 libsqlite3-dev

COPY . /code
WORKDIR /code

RUN git log -n 1 --pretty=format:"%H" > /version

RUN addgroup appuser && adduser --disabled-password appuser --ingroup appuser --gecos ""
RUN mkdir -p /code/tmp && chown appuser:appuser /code/tmp
RUN mkdir -p /code/log && chown appuser:appuser /code/log

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
