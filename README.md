# Chouette2 [![Build Status](https://travis-ci.org/afimb/chouette2.svg?branch=master)](https://travis-ci.org/afimb/chouette2) [![Dependency Status](https://gemnasium.com/afimb/chouette2.png)](https://gemnasium.com/afimb/chouette2) [![Code Climate](https://codeclimate.com/github/afimb/chouette2.png)](https://codeclimate.com/github/afimb/chouette2)

[![Join the chat at https://gitter.im/afimb/chouette2](https://badges.gitter.im/afimb/chouette2.svg)](https://gitter.im/afimb/chouette2?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Chouette2 is an open source web project in Ruby/Rails for editing and viewing Public Transport data. 

Chouette2 is designed as an [SaaS](http://en.wikipedia.org/wiki/Software_as_a_service) platform and can :
* Exchange transport data in several formats : [Neptune](http://www.normes-donnees-tc.org/format-dechange/donnees-theoriques/neptune/), [GTFS](https://developers.google.com/transit/gtfs/reference?hl=fr), [NeTEx](http://www.normes-donnees-tc.org/format-dechange/donnees-theoriques/netex/), CSV
* Create and Edit transport data
* Be requested via a read-only [Restful API](https://en.wikipedia.org/wiki/Representational_state_transfer) 
* [Import, Export and Validate transport data asynchronously](http://github.com/afimb/chouette)
* Use a [multi-tenancy database](http://en.wikipedia.org/wiki/Multitenancy)

Chouette2 uses the Rest Web Service API from [chouette](http://github.com/afimb/chouette) (another open source project) to import, export and validate various transport data.

Feel free to test and access to the free SaaS web site at [http://appli.chouette.mobi](http://appli.chouette.mobi/chouette2/users/sign_in). Two types of access are granted :
* A demo organisation with an existing Public Transport dataset
  * login : demo@chouette.mobi
  * password : chouette
* Create your own organisation : follow the link "Sign up" ("S'inscrire")

Release Notes
-------------

The release notes (in French) can be found in the [CHANGELOG](./CHANGELOG.md) file

Requirements
------------

* [Chouette IEV 3.4.x Web Service](https://github.com/afimb/chouette) (requires Postgresql and Java)
* Ruby 2.3.3
* Bundler 1.13.6
* Proj 4.8.0

Installation
------------

Installation can be found in the [INSTALL](INSTALL.md) page.

More Information
----------------

Complete docs (in French) can be found on the [project website](http://www.chouette.mobi/developpeurs).
Some technical articles are available [on the wiki](../../wiki) too.

FAQ
---

See the [FAQ](FAQ.md) for the answers to commonly asked questions.

API Documentation
-----------------

The description (in French) of the read-only restful API is described in :
* [User manual file](./doc/interfaces/Chouette_API_REST_v1.2.pdf)
* [XSD file](./doc/interfaces/api_rest_v1.xsd)

License
-------

This project is licensed under the CeCILL-B license, a copy of which can be found in the [LICENSE](./LICENSE.md) file.

Project-OSRM Licence
-------------------------

Project-OSRM is licensed under the [ODbL](http://opendatacommons.org/licenses/odbl/) licence.

Release Notes
-------------

The release notes (in French) can be found in [CHANGELOG](./CHANGELOG.md) file

Support
-------

Users looking for support should file an issue on the GitHub [issue tracking page](../../issues), or file a [pull request](../../pulls) if you have a fix available.

Credits
-------

Thanks to Ingolf for his [photo](https://www.flickr.com/photos/ingolfbln/7663851694) under CC BY-SA 2.0 license

