# Renalware

[![Code Climate](https://codeclimate.com/repos/58beee3ed41d600266000147/badges/50451f89d7aad6c2d200/gpa.svg)](https://codeclimate.com/repos/58beee3ed41d600266000147/feed)
[![Test Coverage](https://codeclimate.com/repos/58beee3ed41d600266000147/badges/50451f89d7aad6c2d200/coverage.svg)](https://codeclimate.com/repos/58beee3ed41d600266000147/coverage)
[![Dependency Status](https://gemnasium.com/badges/github.com/airslie/renalware-core.svg)](https://gemnasium.com/github.com/airslie/renalware-core)
[![Gem Version](https://badge.fury.io/rb/renalware-core.svg)](https://badge.fury.io/rb/renalware-core)

Renalware uses demographic, clinical, pathology, and nephrology datasets to improve patient care,
undertake clinical and administrative audits and share data with external systems.

## Technical Overview

renalware-core is a Ruby On Rails [engine](http://guides.rubyonrails.org/engines.html) intended to encapsulate the majority of Renalware's
features in a re-usable [gem](http://guides.rubygems.org/what-is-a-gem/). When a renal unit deploys Renalware, it will create its own _host_
Rails application, and configure it to include the Renalware engine. The host application may be
extremely thin, adding no custom features other than site-specific configuration, or it may include
Ruby, HTML and JavaScript to override or augment renalware-core's features.

While the engine is indented to be deployed inside a host application in production, it can be run
stand-alone in a local development environment (or indeed deployed  in a limited way to somewhere like Heroku) by employing
the _dummy_ host application that ships inside the engine. This dummy app (in `./spec/dummy`)
allows a developer to quickly mount the engine, and is used also used Rails integration tests (which is why
it is in the `./spec` folder)

There are other optional renalware gems which can also be included in the host application,
for example `renalware-ukrdc` which enables sending data to the UKRDC.

### Stack

- Ruby 2.x
- Ruby on Rails 5
- Postgres 10.1+

## Get up and running locally

> An alternative Docker approach will be available shortly

As a Rails developer we assume you are using OS X or Linux (natively or inside a [VM](https://www.virtualbox.org/wiki/Downloads) on Windows),
and have the following installed:

* Git
* Postgres 9.6
* a ruby version manager (e.g. [rbenv](https://github.com/rbenv/rbenv) or [RVM](https://rvm.io/))
* NodeJS required by the [uglifier gem](https://github.com/lautis/uglifier#installation)

### Postgres setup

Set up Postgres user with a password - for development purposes this can be your system login.

```bash
sudo su - postgres
psql template1
```

At the psql prompt run the following (replacing `<username>` and `<password>` accordingly):

```sql
CREATE USER <username> WITH PASSWORD '<password>';
ALTER USER <username> SUPERUSER;
```

### Configure Ruby

Check the `ruby` declaration at the top of the Gemfile to see which version of Ruby to install
using your preferred Ruby version manager.
If using rbenv for example:
```bash
rbenv install 2.4.1
cd renalware-core
rbenv local 2.4.1
```

### Install app dependencies and seed the database with demo data

```bash
gem install bundler --conservative
bundle exec rake db:setup
```

### Run the server

```
$ bin/web
```

> Note `bin/web` starts a sever in the spec/dummy directory. Just executing `rails server` will not work.

Visit [http://localhost:3000](http://localhost:3000)

Login in one of the demo users (in order of role permissiveness):
- superkch
- kchdoc
- kchnurse
- kchguest

They all share the password `renalware`

> Alternatively you can use foreman to start to the web server and the background workers all together
(see the Procfile) and tail the development log to see the output:

    bundle exec foreman start
    tail -f spec/dummy/log/developments.log

## Running background jobs

Some work goes on in the background, for example the processing of HL7 messages.

To start background job processing in development:

    bin/delayed_job run

Run `bin/delayed_job` for other options.

delayed_job logs to its own log. To see the output:

    tail -f spec/dummy/log/delayed_job.log

## Running tests

Install PhantomJS if you don't have it already (check with `phantomjs -v`).
Download from [here](http://phantomjs.org/download.html) of follow these instructions

    wget -O /tmp/phantomjs.tar.bz2 http://airslie-public.s3.amazonaws.com/phantomjs-2.1.1-linux-x86_64.tar.bz2
    tar -xjf /tmp/phantomjs.tar.bz2 -C /tmp
    mv /tmp/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs

### RSpec unit and integration tests

    bundle exec rspec

### Cucumber acceptance tests

Run domain tests which bypass the UI:

    bundle exec cucumber

Run web tests exercising the UI:

    bundle exec cucumber TEST_DEPTH=web --profile rake_web

> Test coverage reports can be found in `coverage/`

## Code Quality

Code quality can be analyzed using by running `codeclimate analyze`. To setup
CodeClimate locally read the setup instructions:

    https://github.com/codeclimate/codeclimate

### Deploying

#### To a server

> Please note the deployment scripts are under development

Please see the [renalware-provisioning](https://github.com/airslie/renalware-provisioning) repo.

#### To a Vagrant VM

Follow [these instructions](https://github.com/airslie/renalware-provisioning#vagrant)
and deploy using capistrano:

```
cap vagrant deploy
```

#### Heroku

Just push `app.json` in the project root defines the deployment steps for Heroku so you should be able
to just create

## General notes

#### Engine migrations

`config.active_record.schema_format = :sql` in `application.rb` is used the engine
uses Postgres views and functions which are not properly supported in a `schema.rb`

##### Creating scenic views

As we are an engine this is the workaround for now.
```sh
  bundle exec spec/dummy/bin/rails generate scenic:view my_view_name
```
Then copy the new files from spec/dummy/db/views and spec/dummy/db/migrations
to ./db/views and ./db/migrations

#### Throttling login attempts

[rack-attack](https://github.com/kickstarter/rack-attack) is configured to throttle login attempts.
Only 10 attempts per username as permitted in any one minute in an attempt to thwart login attacks.

#### Test Configuration

RSpec is configured to silence backtrace from third-party gems. This can be
configured in `.rspec` with `--backtrace` which will display the full backtrace.

#### Debugging

The [awesome_print](https://github.com/awesome-print/awesome_print) gem is available
for improved inspection formatting, for example:

    Rails.logger.ap @variable

To make awesome_print the default formatter in irb, add the following to `~/.irbrc`

    require "awesome_print"
    AwesomePrint.irb!

#### Docker - WIP!

```
docker build -t renalware .
docker-compose run web rake db:create
docker-compose run web rake app:db:create
```
