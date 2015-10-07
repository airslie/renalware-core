Renalware v 2.0 (renal database)
============

Renalware uses demographic, clinical, pathology, and nephrology datasets to improve patient care,
undertake clinical and administrative audits and share data with external systems.

Renalware PHP
-------------

The renalware PHP source code can be found [here](https://github.com/airslie/renalware_php)


Ruby on Rails - Development Setup
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
 In development mode this will create a super admin user with the credentials `superadmin:supersecret`

3. Copy `.env-example` to `.env` and change whatever need to be changed

4. Start the server using Foreman
  ```bash
  $ bundle exec foreman start
  ```
  To see the output of the Rails server, open up another terminal window and run
  ```bash
  $ tail -f log/developments.log
  ```
  Foreman uses Procfile to start all the components that we need for the app (server, workers, ...).  The Procfile file is also used by Heroku.

5. Visit [http://localhost:3000](http://localhost:3000)


Converting an issue to a pull request
-----

First, make sure you have the [Hub](hub.github.com/) tool.  You can use Homebrew to install it: `brew install hub`

Then create a new local branch for the feature/fix/chore that will address the issue.  You will need at least one commit
in that branch for the issue conversion to work.

Convert the issue this way: `hub pull-request -i 999` where 999 is the issue number.  IMPORTANT: make sure
your local branch is checked out and you are not in master.


Tests
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

    $ heroku login
    $ heroku git:remote -a renalware

To deploy:

    $ git push heroku master
    $ heroku open

The app is available at http://renalware.herokuapp.com. It is currently password protected:

    username: renalware
    password: kidney175@stones?
