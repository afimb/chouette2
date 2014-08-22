source 'http://rubygems.org'

gem 'rails', '3.2.18'

platforms :jruby do
  gem 'activerecord-jdbcpostgresql-adapter', '~> 1.3.3'
  gem 'jruby-openssl'
  gem "jruby-rack-worker"
  gem 'warbler'
  gem 'therubyrhino'
end

platforms :ruby do
  gem 'therubyracer', '~> 0.10.2'
  gem 'pg', '~> 0.11.0'
  gem 'sqlite3'
end

# Authentication
gem 'devise', '2.1.3'
gem 'devise-i18n'
gem 'devise-encryptable'
gem 'devise_invitable'

# Map, Geolocalization
gem "map_layers", "0.0.4"
gem "georuby-ext", "0.0.5"

# User interface
gem 'language_engine', '0.0.5'
gem 'gravatar_image_tag'
gem 'calendar_helper', "0.2.5"
gem 'cocoon', "1.1.2"
gem 'formtastic'
gem 'RedCloth'

# Javascript
gem 'jquery-rails', '2.2.1'
gem 'jquery-ui-sass-rails'
gem "modernizr-rails", "~> 2.0.6"
gem 'morrisjs-rails'
gem 'raphael-rails'

# Use twitter bootstrap resources
gem 'bootstrap-sass', '~> 3.1.1'
gem 'bootswatch-rails'
gem 'font-awesome-sass'
gem 'will_paginate-bootstrap'
gem 'simple_form'
gem 'tagmanager-rails', '~> 3.0.1.0'
gem 'typeahead-rails', '~> 0.10.5'
gem "breadcrumbs_on_rails"
gem 'bootstrap-timepicker-rails'

# Format Output
gem 'json'
gem 'rubyzip', :require => 'zip/zip'
gem 'roo'

# Controller
gem 'inherited_resources'
gem 'google-analytics-rails'

# Model
gem 'will_paginate', '~> 3.0'
gem 'ransack'
gem 'squeel'
gem 'ninoxe', :git => 'https://github.com/afimb/ninoxe.git', :branch => :sismo
#gem 'ninoxe',:path => '~/projects/ninoxe'
#gem 'ninoxe',:path => '~/workspace/chouette/ninoxe'
#gem 'ninoxe', '~> 1.0.3'

gem 'acts_as_list', '0.1.6'
gem "acts_as_tree-1.8", '1.1.0', :require => "acts_as_tree"
gem "active_enum"

gem 'rabl'

gem 'delayed_job_active_record'
gem 'dr-apartment', :require => "apartment"

# some views use coffee script
gem 'coffee-rails', '~> 3.2.1'
gem 'coffee-script-source'

gem 'sass-rails',   '~> 3.2.3'
gem 'uglifier', '>= 1.0.3'

group :development do
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'guard'
  gem 'guard-rspec'
  gem 'rails-erd'
end

group :test, :development do
  gem "rspec-rails", "~> 2.0"
  gem "remarkable", "~> 4.0.0.alpha4"
  gem "remarkable_activerecord", "~> 4.0.0.alpha4"
  gem "shoulda-matchers"
  gem 'capybara'
  gem 'launchy'
  gem 'factory_girl_rails', '1.7'
  # gem 'i18n-tasks'
  gem 'rb-inotify', :require => RUBY_PLATFORM.include?('linux') && 'rb-inotify'
  gem 'rb-fsevent', :require => RUBY_PLATFORM.include?('darwin') && 'rb-fsevent'
end

group :production do
   gem "SyslogLogger"
   gem "daemons"
end


