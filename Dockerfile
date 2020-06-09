ARG RUBY_FLAV

FROM ruby:${RUBY_FLAV} AS sysbuild
LABEL maintainer="singh@air-craft.co"

RUN apk add --update --no-cache \
  bash \
  build-base \
  postgresql-dev \
  curl \
  gnupg \
  libffi-dev \
  nodejs \
  sqlite-dev \
  imagemagick-dev \
  tzdata \
  yarn

RUN gem install bundler:2.1.4
RUN gem install rails --version ">6.0" --no-document

ARG APP_PATH
RUN mkdir $APP_PATH
WORKDIR $APP_PATH

COPY ./install-rails.sh /tmp
RUN chmod a+x /tmp/install-rails.sh


#############################################################
# DEPLOYMENT BUILD
#############################################################

FROM sysbuild as finalbuild
ARG APP_PATH
ARG LOCAL_APP_PATH
WORKDIR $APP_PATH

# Copy in the gems and the app
# Note: You need to run bundle install manually in a container to populate these host folders before building the image
COPY ./gems /usr/local/bundle
COPY $LOCAL_APP_PATH $APP_PATH

# Do these to make updated files the lightest weight image update



