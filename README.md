# Chouette2 [![Build Status](https://travis-ci.org/afimb/chouette2.png)](http://travis-ci.org/afimb/chouette2?branch=master) [![Dependency Status](https://gemnasium.com/afimb/chouette2.png)](https://gemnasium.com/afimb/chouette2) [![Code Climate](https://codeclimate.com/github/afimb/chouette2.png)](https://codeclimate.com/github/afimb/chouette2)

Chouette2 is an open source web project in Ruby/Rails to edit and view transport offer. It's designed as an [SaaS](http://en.wikipedia.org/wiki/Software_as_a_service) platform and can :
* Exchange transport data : [Neptune](http://www.chouette.mobi/spip.php?rubrique61), [GTFS](https://developers.google.com/transit/gtfs/reference?hl=fr), [NeTEx](http://www.kizoom.com/standards/netex/), CSV
* Edit transport data
* Validate transport data
* Offer a [Restful API](https://en.wikipedia.org/wiki/Representational_state_transfer) in read-only
* Import and Export Data asynchronously
* Use [multi-tenancy database](http://en.wikipedia.org/wiki/Multitenancy)

It uses java library from another git project to import and export various transport data [chouette](http://github.com/afimb/chouette)

Feel free to test and access to the demonstration web site at [http://www.chouette.mobi](http://www.chouette.mobi/chouette2/users/sign_in). Two types of access are granted :
* A demo organisation with a set of data
  * login : demo@chouette.mobi
  * password : chouette
* Create your own organisation : Must follow the link "Sign up" ("S'inscrire")

Requirements
------------

This code has been run and tested on [Travis](http://travis-ci.org/afimb/chouette2?branch=master) with :
* Ruby 1.9.3
* Postgres 9.x
* Proj 4.8.0

External Deps
-------------

If Linux distribution does't publish RVM package,
install [RVM from sources](./doc/install/rvm.md)

Install ruby 1.9.3
```sh
rvm  install ruby-1.9.3-p448
source ~/.rvm/scripts/rvm
rvm --default use 1.9.3-p448
```

On Debian/Ubuntu/Kubuntu OS : assume depot contains the correct version

```sh
sudo apt-get install postgresql
sudo apt-get install postgresql-client
sudo apt-get install openjdk-7-jdk
sudo apt-get install git
sudo apt-get install unzip
sudo apt-get install proj-bin
sudo apt-get install libproj-dev
sudo apt-get install make
```

Installation
------------


Install chouette-gui-command to import, export and validate transport offer,
Assume Linux user is myuser and its group mygroup
```sh
sudo mkdir -p /usr/local/opt/chouette-command/
sudo chown -R myuser:mygroup /usr/local/opt/chouette-command/
cd /usr/local/opt/chouette-command/
wget http://maven.chouette.cityway.fr/fr/certu/chouette/chouette-gui-command/2.2.0/chouette-gui-command-2.2.0.zip
unzip chouette-gui-command-2.2.0.zip
mv chouette-gui-command-2.2.0.zip chouette-cmd_2.2.0
cd chouette-cmd_2.2.0
sudo chmod a+w .
```

Install web application

Get git source code :
```sh
cd
git clone -b V2_2 git://github.com/afimb/chouette2
cd chouette2
```
Download gem librairies
```sh
gem install bundler
bundle install
```
Create [Postgres database user] (./doc/install/postgresql.md)

Create database and its schema
```sh
RAILS_ENV=production bundle exec rake db:create
RAILS_ENV=production bundle exec rake apartment:migrate
```

The next step assume default path defined by following settings in file [production.rb](./config/environments/production.rb) are unchanged
* ```ImportTask.root```
* ```Export.root```

Create directories
```sh
sudo mkdir -p /var/lib/chouette/imports
sudo mkdir -p /var/lib/chouette/exports
sudo chmod a+x /var/lib/chouette/imports /var/lib/chouette/exports
```

Configuration
-------------

Configure for Generating URLs in Action Mailer Views.
* Edit [production.rb](./config/environments/production.rb) and change ```config.action_mailer.default_url_options```
* see [Action Mailer Configuration documentation](http://guides.rubyonrails.org/action_mailer_basics.html)

Configure SMTP settings.
* Edit [production.rb](./config/environments/production.rb) and change ```ActionMailer::Base.smtp_settings```
* see [Action Mailer Configuration documentation](http://guides.rubyonrails.org/action_mailer_basics.html)

Configure e-mail address shown on mail sent when user registers, re-initialises its password, ...
* Edit [production.rb](./config/environments/production.rb) and change ```config.mailer_sender```

Configure IGN Géoportail Key.
* Edit [production.rb](./config/environments/production.rb) and uncomment and set```config.geoportail_api_key```
* see [API Géoportail documentation](http://api.ign.fr/accueil)

Configure Google Analytics Key.
* Edit [production.rb](./config/environments/production.rb) and change```GA.tracker```
* see [Google Analytics](https://www.google.fr/intl/fr/analytics/)


Run
---

Launch the task to import and export asynchronously
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

Test
----

```sh
bundle exec rake db:create
bundle exec rake apartment:migrate
bundle exec rake spec
```

More Information
----------------

More information can be found on the [project website on GitHub](.).
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
