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

External Deps
-------------
On Debian/Ubuntu/Kubuntu OS : assume depot contains the correct version
```sh
sudo apt-get install postgresql 
sudo apt-get install pgadmin3 
sudo apt-get install openjdk-7-jdk 
sudo apt-get install git 
sudo apt-get install unzip
sudo apt-get install ruby
```

Installation
------------
 
Install [Postgres] (./doc/install/postgresql.md)

Get git code : 
```sh
cd workspace
git clone -b V2_2 git://github.com/afimb/chouette2
cd chouette2
```

Install dependencies
```sh 
sudo apt-get install proj-bin
sudo apt-get install libproj-dev
sudo apt-get install make
```

The next steps assume default path values set in file config/environments/production.rb

Install chouette-gui-command to import and export transport offer : 
```sh
sudo mkdir -p /usr/local/opt/chouette-command/
cd /usr/local/opt/chouette-command/
wget http://maven.chouette.cityway.fr/fr/certu/chouette/chouette-gui-command/2.2.0/chouette-gui-command-2.2.0.zip
unzip chouette-gui-command-2.2.0.zip
mv chouette-gui-command-2.2.0.zip chouette-cmd_2.2.0
cd chouette-cmd_2.2.0
sudo chmod a+w .
```

Build rails application ( Use RAILS_ENV production mode and parameters )
```sh 
setenv RAILS_ENV=production
bundle install
bundle exec rake db:create
```

Create directories ( Use RAILS_ENV production mode and parameters )
```sh 
sudo mkdir -p /var/lib/chouette/imports
sudo mkdir -p /var/lib/chouette/exports
sudo mkdir -p /var/lib/chouette/validations
sudo chmod a+x /var/lib/chouette/imports /var/lib/chouette/exports /var/lib/chouette/validations
```

Run
---

Launch the task to import and export asynchronously
```sh
bundle exec rake jobs:work
```

Launch rails server
```sh
bundle exec rails server
```    

These commands shoud be added in system start up configuration

Test
----

```sh
setenv RAILS_ENV=tests
bundle exec rake db:create
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
