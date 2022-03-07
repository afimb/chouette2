FROM ruby:2.6.9-slim-bullseye as base

RUN apt-get update && apt-get install -y nodejs libgeos-dev proj-bin libproj-dev sendmail dumb-init shared-mime-info sqlite3 postgresql-client wget

RUN gem update --system 3.3.8

RUN gem install bundler -v 1.17.3

# Line below is to try to solve nokogiri build failure
RUN bundle  config build.nokogiri --use-system-libraries

FROM base as builder

RUN apt-get update && apt-get install -y build-essential libpq-dev libsqlite3-dev git unzip make less patch vim

COPY . /code
WORKDIR /code

RUN git log -n 1 --pretty=format:"%H" > /version

RUN bundle  install


FROM base

COPY . /code
WORKDIR /code

RUN addgroup appuser && adduser --disabled-password appuser --ingroup appuser --gecos ""
RUN mkdir -p /code/tmp && chown appuser:appuser /code/tmp
RUN mkdir -p /code/log && chown appuser:appuser /code/log

COPY --from=builder /version /version
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

USER appuser

EXPOSE 3000

ENV RAILS_ENV=production
ENV IEV_DISABLE_CACHE=true
CMD [ "dumb-init", "bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
