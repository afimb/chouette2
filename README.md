# Chouette2 [![Build Status](https://travis-ci.org/dryade/chouette2.png)](http://travis-ci.org/dryade/chouette2?branch=master) [![Dependency Status](https://gemnasium.com/dryade/chouette2.png)](https://gemnasium.com/dryade/chouette2) [![Code Climate](https://codeclimate.com/github/dryade/chouette2.png)](https://codeclimate.com/github/dryade/chouette2)

Chouette2 is an open source web project in Ruby/Rails to edit and view transport offer. It's designed as an [SaaS](http://en.wikipedia.org/wiki/Software_as_a_service) platform and can :
* Exchange transport data : [Neptune](http://www.chouette.mobi/spip.php?rubrique61), [GTFS](https://developers.google.com/transit/gtfs/reference?hl=fr), [NeTEx](http://www.kizoom.com/standards/netex/), CSV
* Edit transport data
* Validate transport data
* Offer a [Restful API](https://en.wikipedia.org/wiki/Representational_state_transfer) in read-only
* Import and Export Data asynchronously
* Use [multi-tenancy database](http://en.wikipedia.org/wiki/Multitenancy)

It uses java library from another git project to import and export various transport data [chouette](http://github.com/dryade/chouette)

Feel free to test and access to the demonstration web site at [http://www.chouette.mobi](http://www.chouette.mobi/chouette2/users/sign_in). Two types of access are granted : 
* A demo organisation with a set of data
  * login : demo@chouette.mobi
  * password : chouette
* Create your own organisation : Must follow the link "Sign up" ("S'inscrire")

Requirements
------------
 
This code has been run and tested on [Travis](http://travis-ci.org/dryade/chouette2?branch=master) with : 
* Ruby 1.8.7
* JRuby 1.6.8 (oraclejdk7, openjdk7, openjdk6)

External Deps
-------------
On Debian/Ubuntu/Kubuntu OS : 
```sh
sudo apt-get install postgresql 
sudo apt-get install pgadmin3 
sudo apt-get install openjdk-7-jdk 
sudo apt-get install git 
sudo apt-get install unzip
```

Installation
------------
 
Install [Postgres] (https://github.com/dryade/chouette2/blob/master/doc/install/postgresql.md)

Install [JRuby] (https://github.com/dryade/chouette2/blob/master/doc/install/jruby.md)

Get git code : 
```sh
cd workspace
git clone -b V2_1_0 git://github.com/dryade/chouette2
cd chouette2
```

**JRuby**

Install dependencies
```sh 
sudo apt-get install tomcat7
sudo apt-get install proj-bin
sudo apt-get install libproj-dev
sudo apt-get install make
```

Install chouette-gui-command to import and export transport offer : 
```sh
sudo mkdir -p /usr/local/opt/chouette-command/
cd /usr/local/opt/chouette-command/
wget http://chouette.dryade.net/chouette-cmd_2.1.0.zip
unzip chouette-cmd_2.1.0.zip
cd chouette-cmd_2.1.0
sudo chmod a+w .
```

Build War ( Use RAILS_ENV production mode and parameters )
```sh 
jgem install bundler --version 1.2.4
jgem install jruby-openssl 
bundle install --path vendor/bundle
bundle exec rake db:create
bundle exec rake war
```

Install war file ( Use RAILS_ENV production mode and parameters )
```sh 
sudo cp chouette2.war /var/lib/tomcat7/webapp/.
sudo mkdir -p /var/lib/chouette/imports
sudo mkdir -p /var/lib/chouette/exports
sudo mkdir -p /var/lib/chouette/validations
sudo chmod a+x /var/lib/chouette/imports /var/lib/chouette/exports /var/lib/chouette/validations
```

**Ruby**
Install chouette-gui-command to import and export transport offer : 
```sh
sudo mkdir -p tmp/chouette-command/
cd tmp/chouette-command/
wget http://chouette.dryade.net/chouette-cmd_2.1.0.zip
unzip chouette-cmd_2.1.0.zip
cd chouette-cmd_2.1.0
sudo chmod a+w .
```

Install
```sh
gem install bundler
bundle install
bundle exec rake db:create
```

Test
----

```sh
bundle exec rake spec
```

More Information
----------------
 
More information can be found on the [project website on GitHub](http://github.com/dryade/chouette2). 
There is extensive usage documentation available [on the wiki](https://github.com/dryade/chouette2/wiki).

API Documentation
-----------------

The description of the restful API is described in : 
* [User manual file](https://github.com/dryade/chouette2/blob/master/doc/interfaces/Chouette_API_REST_v1.2.pdf)
* [XSD file](https://github.com/dryade/chouette2/blob/master/doc/interfaces/api_rest_v1.xsd)

Example Usage 
-------------

Launch the task to import and export asynchronously
```sh
bundle exec rake jobs:work
```

Launch rails server
```sh
bundle exec rails server
```    

License
-------
 
This project is licensed under the CeCILL-B license, a copy of which can be found in the [LICENSE](https://github.com/dryade/chouette2/blob/master/LICENSE.md) file.

Release Notes
-------------

The release notes can be found in [CHANGELOG](https://github.com/dryade/chouette2/blob/master/CHANGELOG.md) file 
 
Support
-------
 
Users looking for support should file an issue on the GitHub issue tracking page (https://github.com/dryade/chouette2/issues), or file a pull request (https://github.com/dryade/chouette2/pulls) if you have a fix available.
