# Renalware

Renalware uses demographic, clinical, pathology, and nephrology datasets to 
improve patient care, undertake clinical and administrative audits and share 
data with external systems.

## Technical Overview

`renalware-core` is an open-source Ruby On Rails [engine](http://guides.rubyonrails.org/engines.html)
that encapsulates Renalware's features in a re-usable [gem](http://guides.rubygems.org/what-is-a-gem/).

In order to deploy an instance of Renalware that is tailored to a
renal unit's needs, it is necessary to create a new host Rails application that 
includes the `renalware-core` gem, adds configuration and HTML/JavaScript/CSS 
overrides, and optionally augments or replaces core behaviour with custom Ruby 
code.

While `renalware-core` is intended to be deployed inside a host application in 
production, it can be run stand-alone in a local development environment using 
the _demo_ host application (`./demo`) that ships inside the engine.

Renalware is built using open source projects including:
- Ruby on Rails framework
- PostgreSQL database

## Running Renalware locally on Mac, Windows or Linux

### Install Microsoft corefonts

* On Ubuntu: `sudo apt install ttf-mscorefonts-installer`
* On NixOS: Add the package `corefonts` to your `configuration.nix`

```
git clone git@github.com:airslie/renalware-core.git
cd ./renalware-core
direnv allow
devbox run setup
devbox services up # CTRL+C to shut it down
```

Additionally, you can run `devbox run reset` which will delete the PostgreSQL
database files for this project and then runs setup again. For a complete reset
(including removing gems) you can simply `rm -rf .devbox`. See `devbox run` for
all available scripts and `devbox.json` to see what they do.

Visit [http://localhost:3000](http://localhost:3000) and login in one of the demo users
(in order of role permissiveness):
- superkch
- kchdoc
- kchnurse
- kchguest

They all share the password `renalware`.

## Devbox

Devbox, Direnv & process-compose are a suite of tools designed to make local
development easier. It manages package dependencies, aids in initial setup and 
spins up related services. Under the hood it uses Nix which is a declarative, 
immutable package manager.

Devbox is a cross-platform project scoped package manager. Think npm + brew.
See devbox.json for the configuration and devbox.lock for the versions. Docs at
https://www.jetify.com/docs/devbox/.

Direnv sets up your local environment when entering a directory. Think 
chruby/dotenv. It's integrated with Devbox. Docs at https://direnv.net/.

process-compose spins up multiple possibly dependent services or processes. Like
a local docker-compose. process-compose is integrated with Devbox. See 
`./process-compose.yml` for the configuration. Packages may also install
additional configuration in `.devbox/virtenv/<package>/process-compose.yml`. Docs
at https://f1bonacc1.github.io/process-compose/launcher/.


