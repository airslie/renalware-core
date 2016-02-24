# Renalware

Renalware uses demographic, clinical, pathology, and nephrology datasets to improve patient care,
undertake clinical and administrative audits and share data with external systems.

## Setup

As a Rails developer we assume you have the following setup on your machine:

* Git
* Postgres
* Heroku Toolbelt (with a Heroku Account)
* a ruby version manager (e.g. RVM)

1. Setup a Postgres user with a password, for development purposes this can be your system login.

  ```
  sudo su - postgres
  psql template1
  ```

  At the psql prompt run the following (replacing <username> and <password> accordingly):

  ```sql
  CREATE USER <username> WITH PASSWORD '<password>';
  ALTER USER <username> SUPERUSER;
  ```

2. Ensure you have the correct Ruby version installed (verify the version in the Gemfile) and setup your Ruby
environment with your prefered Ruby version and Gemset management tool (i.e. RVM).

3. Ensure bundler installed

4. Setup the application

  ```
  bin/setup
  ```

  Important: Read the instructions outputted at the end of the setup process.

## Running the Server

    bundle exec foreman start

To see the output from the Rails server, open up another terminal window and run:

    tail -f log/developments.log

Foreman uses a Procfile to start all the components that we need for the app (server, workers, ...).  The Procfile file is also used by Heroku which is used for hosting staging and demo servers.

Visit [http://localhost:3000](http://localhost:3000).

## Run the tests

1. Setup a test database

  ```
  RAILS_ENV=test bin/rake db:create
  bin/rake db:test:load
  ```

2. Run the test suite

  ```
  bin/rake
  ```

Test coverage reports can be found in `coverage/`

### Configuration

RSpec is configured to silence backtrace from third-party gems. This can be
configured in `.rspec` with `--backtrace` which will display the full backtrace.

### Acceptance Tests

To run the acceptance tests without the UI:

    bin/cucumber

To run the acceptance tests with the UI:

    TEST_DEPTH=web bin/cucumber

## Deployment to demo server

Heroku hosts our demo server.

Setup the remote repository:

    heroku login
    heroku git:remote -a renalware-demo

To deploy:

    git push heroku master
    heroku open

The app is available at http://renalware-demo.herokuapp.com. It is password protected:

    username: renalware
    password: lister

## Deployment to staging server

Heroku hosts our demo server, and acceptance apps.

Setup the remote repository:

    heroku login
    heroku git:remote -a renalware-staging -r staging

To deploy:

    git push staging master
    heroku open

To reset the database:

    heroku pg:reset DATABASE -a renalware-staging
    heroku run rake db:migrate db:seed -a renalware-staging

Note: you might have to restart the dyno to pick-up the new database structure:

    heroku restart -a renalware-staging

The app is available at http://renalware-staging.herokuapp.com. It is password protected:

    username: renalware
    password: lister

Review app: if the automatic deployment fails, there is no known solution for it.
