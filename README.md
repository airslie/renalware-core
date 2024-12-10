# Renalware

Renalware uses demographic, clinical, pathology, and nephrology datasets to improve patient care,
undertake clinical and administrative audits and share data with external systems.

## Technical Overview

renalware-core is a Ruby On Rails [engine](http://guides.rubyonrails.org/engines.html) encapsulating the majority of Renalware's
features in a re-usable [gem](http://guides.rubygems.org/what-is-a-gem/). When a renal unit deploys Renalware, it will create its own _host_
Rails application, and configure it to include the Renalware engine. The host application may be
extremely thin, adding no custom features other than site-specific configuration, or it may include
Ruby, HTML and JavaScript to override or augment renalware-core's features.

While the engine is intended to be deployed inside a host application in production, it can be run
stand-alone in a local development environment by employing
the _demo_ host application (`./demo`) that ships inside the engine.

Renalware is built using using open source projects including:
- Ruby on Rails framework
- PostgreSQL database

## Running Renalware on your Mac or PC

Install `git` if not already installed on your system.
Install the [Docker Engine](https://docs.docker.com/engine/install/) and ensure it is running.

```
git clone git@github.com:airslie/renalwarev2.git
cd ./renalwarev2
docker-compose run web bundle exec rake db:setup
docker-compose up -d
```

Visit [http://localhost:3000](http://localhost:3000) and login in one of the demo users
(in order of role permissiveness):
- superkch
- kchdoc
- kchnurse
- kchguest

They all share the password `renalware`
