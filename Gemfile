source 'https://rubygems.org'

gem 'bundler', '~> 1.13.6'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.7'

gem "passenger", ">= 5.0.25", require: "phusion_passenger/rack_handler"

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 2.7.2'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.0.5' # Update to v4 for Rails 4.2
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 2.5.3'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring', '~> 1.7.2', group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# API Rest
gem 'sawyer', '~> 0.6.0'
gem 'faraday_middleware', '~> 0.11.0.1'

gem 'figaro', '~> 1.1.1'

platforms :ruby do
  gem 'therubyracer', '~> 0.12'
  gem 'pg'
  gem 'sqlite3'
end

gem 'activerecord-postgis-adapter', '~> 3.1.4'
gem 'polylines'

# Authentication
gem 'devise', '~> 3.5.10'
gem 'devise-encryptable'
gem 'devise_invitable'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-openid-connect'

# Map, Geolocalization
gem 'map_layers', '0.0.5'
gem 'rgeo', '~> 0.5.2'
gem 'georuby-ext', '0.0.5'
gem 'georuby', '2.3.0' # Fix version for georuby-ext because api has changed

gem 'mimemagic'

# User interface
gem 'language_engine', git: 'https://github.com/rutebanken/language_engine'
gem 'calendar_helper', '0.2.5'
gem 'cocoon'
gem 'formtastic', '2.3.1'
gem 'RedCloth'
gem 'simple_form', '~> 3.1.0'
gem 'font-awesome-sass', '~> 4.2.0'
#gem 'will_paginate-bootstrap', '~> 1.0.1'
gem 'breadcrumbs_on_rails'

# Format Output
gem 'json'
gem 'rubyzip', '~> 1.1.7'
gem 'roo'

# Controller
gem 'inherited_resources'
gem 'google-analytics-rails', '~> 1.1.0'

# Model
gem 'ransack'
gem 'squeel'
gem 'kaminari', '~> 0.16.3'
gem 'bootstrap-kaminari-views', '~> 0.0.5'
gem 'kaminari-i18n', '~> 0.3.2'

gem 'enumerize', '~> 0.10.0'
#gem 'foreigner', '~> 1.7.4'
gem 'deep_cloneable', '~> 2.0.0'
gem 'acts-as-taggable-on', '>= 3'

gem 'acts_as_list', '~> 0.6.0'
gem 'acts_as_tree', '~> 2.1.0', require: 'acts_as_tree'

gem 'rabl'

gem 'delayed_job_active_record'
gem 'devise-async'
gem 'apartment', '~> 1.0.0'

gem 'newrelic_rpm'
gem 'letter_opener'

gem 'migration_data'

gem 'responders', '~> 2.0'

gem 'pundit'

group :development do
  gem 'capistrano', '2.13.5'
  gem 'capistrano-ext'
  gem 'guard'
  gem 'guard-rspec'
  gem 'rails-erd'
  # MetaRequest is incompatible with rgeo-activerecord
  # gem 'meta_request'
  gem 'quiet_assets', '~> 1.0'
  gem 'simplecov', '~> 0.10.0'
  gem 'web-console', '~> 2.0'
  platforms :ruby_20, :ruby_21, :ruby_22, :ruby_23 do
    #gem 'better_errors'
    gem 'binding_of_caller'
  end
end

group :test, :development do
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.4.2'
  gem 'fakeweb'
  gem 'capybara', '~> 2.8.1'
  gem 'poltergeist'
  gem 'launchy'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'rb-inotify', require: RUBY_PLATFORM.include?('linux') && 'rb-inotify'
  gem 'rb-fsevent', require: RUBY_PLATFORM.include?('darwin') && 'rb-fsevent'
  gem 'transpec'
  gem 'database_cleaner'
  gem 'shoulda-matchers', '~> 2.8.0'
end

group :production do
  gem 'SyslogLogger', require: 'syslog/logger'
  gem 'daemons'
end


# IEVKIT
gem 'ievkit',  git: 'https://github.com/rutebanken/ievkit.git', branch: 'master' #'~> 0.3.0'
gem 'ievkit_views', git: 'https://github.com/rutebanken/ievkit_views.git', branch: 'master' #'~> 0.2.2'

# I18n
gem 'rails-i18n', '~> 4.0.0'
gem 'devise-i18n'
gem 'chouette2-i18n', git: 'https://github.com/rutebanken/chouette2-i18n.git', :branch => 'master'
gem 'chouette-projects-i18n', git: 'https://github.com/rutebanken/chouette-projects-i18n.git', :branch => 'master'

# Rails Assets
source 'https://rails-assets.org' do
  gem 'rails-assets-morrisjs', '~> 0.5.1'
  gem 'rails-assets-raphael', '~> 2.1.3'
  gem 'rails-assets-footable', '~> 2.0.3'

  # Use twitter bootstrap resources
  gem 'rails-assets-bootstrap-sass-official', '~> 3.3.7'
  gem 'rails-assets-tagmanager', '~> 3.0.1.0'
  gem 'rails-assets-typeahead.js', '~> 0.10.5'
  gem 'rails-assets-typeahead.js-bootstrap3.less'
  gem 'rails-assets-respond'
  gem 'rails-assets-eonasdan-bootstrap-datetimepicker', '~> 3.1.4'
  gem 'rails-assets-jquery-tokeninput', '~> 1.7.0'

  gem 'rails-assets-modernizr', '~> 2.0.6'
  gem 'rails-assets-jquery-ui', '~> 1.11.4'
end
