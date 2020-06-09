# HKS's Rails 6 Fresh Start

## Goals...
* Allow a clean install of the latest rails
* ..that's dev and prod friendly
* ...and built & generated entirely in container (ie zero-dep on the host ruby/rails setup)

## Featuring...
* All based on alpine (lightweight, small)
* Rails 6 (>6.0)
* Postgres 11.1 (see `.env`)
* Webpacker with ReactJS (see Dockerfile)
* ~~Yarn `node_modules` under `vendor/`~~ todo
* Multi-stage Dockerfile for minimal overhead when updating
* .env file for build/install settings (postgres credentials, build image name, etc)


## Setup Instructions

1. Download this repo (clone if you must but then replace remote with your project repo)

2. Edit the .env file

3. Edit `install-rails.sh` if you don't want ReactJS or Webpacker

4. `docker-compose build`

5. `source .env; docker-compose run --rm web /tmp/install-rails.sh $APP_PATH`

6. Your `/app` & `/gem` folders should now be populated with good stuff

7. Go Gem shopping (see below). Also move `gem react-rails` from the bottom to omewhere nicer

8. `docker-compose run --rm web bundle install` to install the new gems

9. `docker-compose up`

10. Load 0.0.0.0:3000...🙏...🎉

11. DNF to git init/add/commit/push as desired/required (remember this is a _project_ repo now, not a "rails quickstaert)

To build the final image for pushing to live...

12. `docker-compose build` to sync the latest image with your local (host) volumes for pushing to docker



### Notes

* DONT run `bundle install`, `yarn install`, or rails locally! Use docker-compose run...
* Remember this is an _app project_ repo now, no longer a "rails quickstart" thing. you'll want a new repo for your project, even if you forked the quickstart repo
* You can't use `docker-compose up` to start the process



### ReactJS

See https://github.com/reactjs/react-rails#get-started-with-webpacker for more...


## Do Stuff

Just prefix everything you normally want to do (`bundle`, `yarn`, `rails`, etc) with `docker-compose run web ` (`bundle install` etc)....You can prob get away with some things locally like `rails g controller...` but at your own risk as your host sys is not the same as the docker container.


## Gotchas 😱

* If you see missing environ vars message you likely running docker-compose in a subfolder rather than the project root
* The docker-compose volume will cause the host version to overwrite anything on the image when it is containerized so the host needs to be the authoritative. Ie, Use `docker-compose run --rm web bundle install` manually. Don't rely on the `RUN bundle install` in the Dockerfile + rebuild expected it to "copy out" to the host
* That being said, postgres seems to work that way. It doesn't. The database is created and setup on the fly when the image is containerized (run). So d-c makes the volume and then the postgres bootstrap populates. That's why you need a volume to preserve your database data
* So if you want to change password or users on postgres you either need to delete the data locally and then re-run or you need to do it manually (`docker-compose run web --rm psql ....`)




## Gem Shopping

```
# Coding tools
gem 'deep_cloneable'
gem 'aasm'

# DB / Models
gem 'audited'  # Object history automagically
gem 'money-rails'
gem 'phony_rails'
gem 'uk_postcode'
gem 'activerecord-session_store'

# Features & Engines (Front & Back)
gem 'devise' # auth
gem 'administrate' # auto-admin
gem 'administrate-field-nested_has_many'
gem 'wicked'  # wizards
gem 'kaminari' # paginator
gem 'ransack' # search

# Web/Networking
gem 'rest-client'

# Authgem 'awesomplete'
gem 'kaminari' # paginator

# Views
gem 'haml-rails'
gem 'liquid'
gem 'awesomplete'
gem 'country_select'
gem 'filepicker-rails'
gem 'csv_shaper'
gem 'prawn-rails' # PDF Making
gem 'prawn-qrcode'
gem 'ruby-progressbar'

# Caching
gem 'readthis' # redis-backed memcache replacer
gem 'redis'
gem 'hiredis' # C redis client wrapper

# Security
gem 'secure_headers' # browser header config

# 3rd Parry Services
gem 'stripe'

# Development
gem 'dotenv-rails'
gem 'ruby-debug-ide' # Rubymine debugging
gem 'debase'
gem 'pry-rails'
gem 'pry-byebug'
gem 'pry-remote'
gem 'selenium-webdriver'
gem 'exception_notification'
gem 'newrelic_rpm'
gem 'mailcatcher' # sent emails pop up in browser
gem 'letter_opener', '~> 1.7'  # Opens sent emails in browser (might not work under docker...)
gem 'web-console'

# Production
gem 'rails_12factor'  # https://github.com/heroku/rails_12factor

# Test
gem 'timecop'  # time altering for testing



group :development do
  gem 'derailed_benchmarks'
  gem 'foreman'
  gem 'guard-rspec', require: false
  gem 'meta_request'
  gem 'rails_real_favicon'
  gem 'rb-fsevent', :require => false
  gem 'seed_dump'
  gem 'stackprof'
  gem 'terminal-notifier-guard', :require => false
end

```

## Thanks

* https://github.com/zazk/Rails-6-Docker-Alpine
* https://gist.github.com/erdostom/5dd400cbba17d44b52b2f74b038fcb85
* https://github.com/DiveIntoHacking/docker-compose-rails-6/
* https://github.com/chrisf/rails-postgres-docker/blob/master/Dockerfile
