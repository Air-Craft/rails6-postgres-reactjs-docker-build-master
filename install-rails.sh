#!/bin/sh

# Run this as a script as to populate the d-c volumes.
# Otherwise the gems (if installed via Dockerfile) get erased when we first run the image

set -xe


APP_PATH=$1

cd $APP_PATH

echo "Installing rails to `pwd`"

gem install bundler
gem install rails --version ">6.0" --no-document

# Edit out ReactJS parts if you don't want them
rails new . --skip-git --webpacker --webpack=react --database=postgresql
echo "gem 'react-rails'" >> Gemfile
bundle install
rails generate react:install

rm /tmp/install-rails.sh


