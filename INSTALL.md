Chouette2 External Dependencies
-------------------------------

Install the Chouette IEV 3.X Web Service
[see how to](https://github.com/afimb/chouette/blob/master/README.md)

The next steps assume that :
* a Chouette IEV Web Service is running (on localhost, port 8080)
* a Postgres database exists (chouette2 on localhost, port 5432) with a postgres user (chouette, with password chouette)

On Debian/Ubuntu/Kubuntu OS : assumes that the depot contains the correct version
```sh
sudo apt-get install libpq-dev git unzip libgeos-dev proj-bin libproj-dev make
```
On OSX : assumes that the depot contains the correct version
```sh
brew install libffi geos proj
```

If your Linux distribution doesn't publish an RVM package,
install [RVM from sources](./doc/install/rvm.md)

Install ruby 2.1.x
```sh
rvm install ruby-2.1.x
rvm --default use 2.1.x
```

Install bundler 1.10.x
```sh
gem install bundler -v 1.10.x
```

Chouette2 Installation
----------------------

On Debian, chouette can also be installed as a package : see [debian packages](http://packages.chouette.cityway.fr/debian/chouette)

Install web application

Get git source code :
```sh
cd
git clone -b V3_2 git://github.com/afimb/chouette2
cd chouette2
```
Download gem librairies
```sh
bundle install
```


Chouette2 application config file
---------------------------------

Copy and fill application.yml
```
cp config/application.example.yml config/application.yml
```

1. Configure **domain_name** with your domain, for example: `domain_name: chouette.mobi`
   See [Action Mailer Configuration documentation](http://guides.rubyonrails.org/action_mailer_basics.html)
2. Configure SMTP settings with all lines started with `smtp_`
   For using SMTP you must set **'smtp'** in `smtp_delivery_method`
   See [Action Mailer Configuration documentation](http://guides.rubyonrails.org/action_mailer_basics.html)
3. Fill **secret_key_base** and **devise_secret_key** by executing `rake secret` in your terminal
   See [Rails documentation](http://guides.rubyonrails.org/4_1_release_notes.html#config-secrets-yml)
4. Configure the Chouette IEV Web Service url `api_endpoint`
5. Configure the Google Analytics Key `google_analytics_tracker`
   See [Google Analytics](https://www.google.fr/intl/fr/analytics/)
6. Configure the IGN Géoportail Key `geoportail_api_key`
   See [API Géoportail documentation](http://api.ign.fr/accueil)
7. Configure OSRM Backend URL `osrm_endpoint`
   See [Project-OSRM](https://github.com/Project-OSRM/osrm-backend/wiki/Api-usage-policy)
8. If you want to enable Google oauth2 authentification `google_client_id` and `google_secret_id`
   See [Google Oauth2](https://console.developers.google.com)
9. If you want to enable Facebook oauth2 authentification `facebook_client_id` and `facebook_secret_id`
   See [Facebook Oauth2](https://developers.facebook.com)

Chouette2 database configuration
--------------------------------

Add the PostGIS extension to your database
```
RAILS_ENV=production bundle exec rake db:gis:setup
```
Update the database schema
```sh
RAILS_ENV=production bundle exec rake db:migrate
```
Prepare the static resources (assets)
```sh
RAILS_ENV=production bundle exec rake assets:clobber assets:precompile
```

Chouette2 others configuration
------------------------------

Configure asset access (Must be True if you use Webrick, or False if you use Apache or Nginx).
* Edit [production.rb](./config/environments/production.rb) and change ```config.serve_static_assets```

Configure the way Chouette2 sends e-mail.
* Edit [devise_async.rb](./config/initializer/devise_async.rb) and uncomment and set```Devise::Async.enabled``` ( true if you want to use asynchronously and false otherwise )
* see [Devise Async specification](https://github.com/mhfs/devise-async)

Run Chouette2
-------------

Launch the task if you want to send mail asynchronously (See previous section to de-activate it)
```sh
RAILS_ENV=production bundle exec rake jobs:work
```
This task may be added in the system start-up configuration

Launch the Rails server with [WEBrick](http://guides.rubyonrails.org/command_line.html#server-with-different-backends) ( default RoR web server, note: Webrick runs on default port 3000)
```sh
RAILS_ENV=production bundle exec rails server
```

This task may be added in the system start-up configuration.
Instead of using WEBrick, the Rails application may be deployed on [Phusion Passenger](https://www.phusionpassenger.com/) with an [Apache](http://httpd.apache.org/) or [NGinx](http://nginx.com/) front-end, to make server faster and more robust.

Apache like NGinx can serve static resources,
so change parameter ```serve_static_assets``` to false in [production.rb](./config/environments/production.rb)

Test Chouette2
--------------

```sh
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake spec
```
