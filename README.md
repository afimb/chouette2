# Chouette2 [![Build Status](https://travis-ci.org/afimb/chouette2.svg?branch=master)](https://travis-ci.org/afimb/chouette2) [![Dependency Status](https://gemnasium.com/afimb/chouette2.png)](https://gemnasium.com/afimb/chouette2) [![Code Climate](https://codeclimate.com/github/afimb/chouette2.png)](https://codeclimate.com/github/afimb/chouette2)

Chouette2 is an open source web project in Ruby/Rails to edit and view transport offer. It's designed as an [SaaS](http://en.wikipedia.org/wiki/Software_as_a_service) platform and can :
* Exchange transport data : [Neptune](http://www.chouette.mobi/spip.php?rubrique61), [GTFS](https://developers.google.com/transit/gtfs/reference?hl=fr), [NeTEx](http://www.kizoom.com/standards/netex/), CSV
* Edit transport data
* Offer a [Restful API](https://en.wikipedia.org/wiki/Representational_state_transfer) in read-only
* [Import, Export and Validate transport data asynchronously](http://github.com/afimb/chouette)
* Use [multi-tenancy database](http://en.wikipedia.org/wiki/Multitenancy)

It uses Rest Web Service API from another git project to import, export and validate various transport data [chouette](http://github.com/afimb/chouette)

Feel free to test and access to the free SaaS web site at [http://appli.chouette.mobi](http://appli.chouette.mobi/chouette2/users/sign_in). Two types of access are granted :
* A demo organisation with a set of data
  * login : demo@chouette.mobi
  * password : chouette
* Create your own organisation : Must follow the link "Sign up" ("S'inscrire")

Release Notes
-------------

The release notes can be found in [CHANGELOG](./CHANGELOG.md) file

Requirements
------------

* [Chouette Web Service IEV](https://github.com/afimb/chouette) 3.X (that requires Postgres and Java)
* Ruby 1.9.3 or 2.1.6
* Bundler 1.10.3
* Proj 4.8.0

External Deps
-------------

Install Chouette Web Service IEV [see how to](https://github.com/afimb/chouette/readme.md) 3.X.
Next steps assumes that :
* a Chouette Web Service IEV is running (on localhot port 8080)
* a Postres database exists (chouette2 on localhot, port 5432) with a postgres user (chouette, with password chouette)

On Debian/Ubuntu/Kubuntu OS : assume depot contains the correct version
```sh
sudo apt-get install libpq-dev
sudo apt-get install git
sudo apt-get install unzip
sudo apt-get install proj-bin
sudo apt-get install libproj-dev
sudo apt-get install make
```

If Linux distribution does't publish RVM package,
install [RVM from sources](./doc/install/rvm.md)

Install ruby 2.1.6
```sh
rvm  install ruby-2.1.6
rvm --default use 2.1.6
```

Install bundler 1.10.3
```sh
gem install bundler -v 1.10.3
```

Installation
------------

On debian, chouette can also be installed as a package : see [debian packages](http://packages.chouette.cityway.fr/debian/chouette)

Install web application

Get git source code :
```sh
cd
git clone -b V3_0 git://github.com/afimb/chouette2
cd chouette2
```
Download gem librairies
```sh
bundle install
```
Update database schema
```sh
RAILS_ENV=production bundle exec rake db:migrate
```
Prepare static resources (assets)
```sh
RAILS_ENV=production bundle exec rake assets:clobber assets:precompile
```

Configuration
-------------

Configure for Generating URLs in Action Mailer Views.
* Edit [production.rb](./config/environments/production.rb) and change ```config.action_mailer.default_url_options```
* see [Action Mailer Configuration documentation](http://guides.rubyonrails.org/action_mailer_basics.html)

Configure assets access (Must be true if you use Webrick or false if you use Apache or Nginx).
* Edit [production.rb](./config/environments/production.rb) and change ```config.serve_static_assets```

Configure SMTP settings.
* Edit [production.rb](./config/environments/production.rb) and change ```ActionMailer::Base.smtp_settings```
* see [Action Mailer Configuration documentation](http://guides.rubyonrails.org/action_mailer_basics.html)

Configure e-mail address shown on mail sent when user registers, re-initialises its password, ...
* Edit [production.rb](./config/environments/production.rb) and change ```config.mailer_sender```

Configure Rails secret key.
* Edit [secrets.yml](./config/secrets.yml) and uncomment and set```secret_key_base```
* see [Rails documentation](http://guides.rubyonrails.org/4_1_release_notes.html#config-secrets-yml)

Configure address to Chouette Web Service IEV.
* Edit [secrets.yml](./config/secrets.yml) and uncomment and set```api_endpoint```

Configure Google Analytics Key.
* Edit [secrets.yml](./config/secrets.yml) and change```google_analytic_tracker```
* see [Google Analytics](https://www.google.fr/intl/fr/analytics/)

Configure IGN Géoportail Key.
* Edit [secrets.yml](./config/secrets.yml) and uncomment and set```geoportail_api_key```
* see [API Géoportail documentation](http://api.ign.fr/accueil)

Configure the way that it sends email.
* Edit [devise_async.rb](./config/initializer/devise_async.rb) and uncomment and set```Devise::Async.enabled``` ( true if you want to use asynchronously and false otherwise )
* see [Devise Async specification](https://github.com/mhfs/devise-async)

Run
---

Launch the task if you want to send mail asynchronously (See previous chapter to desactivate it)
```sh
RAILS_ENV=production bundle exec rake jobs:work
```
This task may be added in system start up configuration

Launch rails server with [WEBrick](http://guides.rubyonrails.org/command_line.html#server-with-different-backends) ( default RoR web server, note: running on default port 3000)
```sh
RAILS_ENV=production bundle exec rails server
```

This task may be added in system start up configuration.
Instead of using WEBrick, Rails application may be deployed on [Pushion Passenger](https://www.phusionpassenger.com/) with an [Apache](http://httpd.apache.org/) or [NGinx](http://nginx.com/) front-end, to make server faster and more robust.

Apache like NGinx can serve static resources
so, change parameter ```serve_static_assets``` to false in [production.rb](./config/environments/production.rb)

Test
----

```sh
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake spec
```

More Information
----------------

More information can be found on the [project website](http://www.chouette.mobi/developpeurs).
There is extensive usage documentation available [on the wiki](../../wiki).

API Documentation
-----------------

The description of the restful API is described in :
* [User manual file](./doc/interfaces/Chouette_API_REST_v1.2.pdf)
* [XSD file](./doc/interfaces/api_rest_v1.xsd)

License
-------

This project is licensed under the CeCILL-B license, a copy of which can be found in the [LICENSE](./LICENSE.md) file.

Release Notes
-------------

The release notes can be found in [CHANGELOG](./CHANGELOG.md) file

Support
-------

Users looking for support should file an issue on the GitHub [issue tracking page](../../issues), or file a [pull request](../../pulls) if you have a fix available.

Credits
-------

Thanks to Ingolf for his [photo](https://www.flickr.com/photos/ingolfbln/7663851694) under CC BY-SA 2.0 license

