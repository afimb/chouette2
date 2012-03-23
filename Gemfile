source 'http://rubygems.org'

gem 'rails', '3.1.3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'user_interface', :git => 'git://sim.dryade.priv/user_interface'

gem 'apartment', :git => 'git://github.com/dryade/apartment.git'

gem "map_layers", "~> 0.0.4"

platforms :jruby do
  gem 'activerecord-jdbcpostgresql-adapter', :git => 'git://github.com/dryade/activerecord-jdbc-adapter.git'    
  gem 'activerecord-jdbcsqlite3-adapter'
  gem 'jruby-openssl'
end

platforms :ruby do
  gem 'pg', '~> 0.11.0' 
  gem 'sqlite3'
end

gem 'json'
gem 'warbler'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.5'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'coffee-script-source'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

gem 'formtastic'
gem 'inherited_resources'
gem 'will_paginate', '~> 3.0'
gem 'ransack'
gem 'squeel'

gem 'chouette-ninoxe', :git => 'git://chouette.dryade.priv/ninoxe'#, :path => '~/projects/ninoxe'

group :development do 
  gem 'autotest-rails'
  gem 'autotest-notification' 
  gem 'capistrano'
  gem 'capistrano-ext'   
  gem 'guard'
  gem 'guard-rspec'
  #gem 'jekyll'
  gem 'RedCloth'
end

group :test, :development, :cucumber do
  gem "rspec"
  gem "rspec-rails"
  gem "remarkable", "~> 4.0.0.alpha4"           
  gem "remarkable_activerecord", "~> 4.0.0.alpha4" 
  gem "shoulda", :git => 'git://github.com/thoughtbot/shoulda.git'
end

group :cucumber do
  gem 'capybara'
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'launchy'
  gem 'pickle', :git => 'git://github.com/mflorisson/pickle.git'
end

group :test, :cucumber do
  gem 'capybara'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'factory_girl'
end

group :production do
   gem "SyslogLogger"
end

