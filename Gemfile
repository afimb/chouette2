source 'http://rubygems.org'

gem 'rails', '3.1.3'
gem 'devise'

gem "ffi-proj4", :git => 'git://github.com/dryade/ffi-proj4.git'

platforms :jruby do
  gem 'activerecord-jdbcpostgresql-adapter', :git => 'git://github.com/dryade/activerecord-jdbc-adapter.git'
  gem 'activerecord-jdbcsqlite3-adapter'
  gem 'jruby-openssl'
  gem "jruby-rack-worker"
  gem 'warbler'   
  gem "jruby-rack-worker"
end

platforms :ruby do    
  gem 'pg', '~> 0.11.0' 
  gem 'sqlite3'
end

gem "map_layers", "~> 0.0.4"
gem "georuby-ext", :git => 'git://github.com/dryade/georuby-ext.git'

#gem 'user_interface', :git => 'git://github.com/dryade/user-interface.git'
gem 'user_interface', :git => 'git://sim.dryade.priv/user_interface'
gem 'json'
gem 'cocoon'
gem 'formtastic'
gem 'inherited_resources'
gem 'will_paginate', '~> 3.0'
gem 'ransack'
gem 'squeel'
gem 'RedCloth'
gem 'jquery-rails'
gem 'modernizr'

gem "acts_as_tree", :git => "git://github.com/dryade/acts_as_tree.git"
gem 'ninoxe', :git => 'git://chouette.dryade.priv/ninoxe' #, :path => '~/Projects/Ninoxe'
gem 'acts_as_list', '0.1.6'

gem 'composite_primary_keys', '4.1.2'
gem 'delayed_job_active_record'
gem 'apartment', :path => '~/projects/apartment' #,:git => 'git://github.com/dryade/apartment.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '= 3.1.4'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'coffee-script-source'
  gem 'uglifier', '>= 1.0.3'
  gem 'therubyrhino', :platform => :jruby
  gem 'therubyracer', :platform => :ruby
end

group :development do 
  gem 'capistrano'
  gem 'capistrano-ext'   
  gem 'guard'
  gem 'guard-rspec'
end

group :test, :development do
  gem "rspec"
  gem "rspec-rails"
  gem "remarkable", "~> 4.0.0.alpha4"           
  gem "remarkable_activerecord", "~> 4.0.0.alpha4" 
  gem "shoulda", :git => 'git://github.com/thoughtbot/shoulda.git'
end

group :test do
  gem 'capybara'     
  gem 'launchy'
  gem 'database_cleaner', :git => 'git://github.com/dnagir/database_cleaner.git', :branch => 'postgre_jruby_issue'
  gem 'factory_girl_rails', '1.7'
end

group :production do
   gem "SyslogLogger"
end

