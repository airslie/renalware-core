Renalware v 2.0 (renal database)
============

Renalware PHP
-------------
The renalware PHP source code can be found [here](https://github.com/airslie/renalware_php)

Ruby / Rails - Development Setup
--------------------
1. Setup a postgres user with a password, for development purposes this can be your system login.
  ```bash
  $ sudo su - postgres
  $ psql template1
  ```
  At the psql prompt run the following (replacing <username> and <password> accordingly):
  ```sql
  CREATE USER <username> WITH PASSWORD '<password>';
  ALTER USER <username> SUPERUSER;
  ```

2. Create a renalware database
  ```bash
  $ rake db:create:all
  $ rake db:migrate
  $ rake db:seed
  ```
  At the prompt you can create a bespoke `User` for authentication or accept defaults, this will create a user with the credentials `superadmin:supersecret`

3. Visit [http://localhost:3000](http://localhost:3000)

TESTS
-----

1. Setup a test database
  ```bash
  $ bundle exec rake db:create RAILS_ENV=test
  $ bundle exec rake db:test:load
  ```
  
2. Run the test suite
  ```bash
  $ bundle exec rake
  ```

Test coverage reports can be found in `coverage/`

Deployment
----------

Deployment is currently on Heroku. Get yourself a copy of the Heroku toolbelt: https://toolbelt.heroku.com

Assuming that you've got a Heroku account and are added to the app, you ought to
be able to:

> heroku login
> heroku git:remote -a renalware

To deploy:
> git push heroku master
> heroku open

The app is available at http://renalware.herokuapp.com. It is currently password protected:

username: renalware
password: kidney175@stones?

Advanced SSH stuff
------------------

More info:
https://www.cleardb.com/developers/ssl_connections
