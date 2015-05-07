Renalware v 2.0 (renal database)
============

PHP - Setup
-----------

If you're setting up the legacy (v1) PHP app, the following should be enough to get going...

1. Setup a mysql user renalware with a password

> GRANT CREATE ON *.* TO 'renalware'@'localhost' IDENTIFIED BY 'password';
> GRANT ALL PRIVILEGES on renalware.* to 'renalware'@'localhost' identified by 'password';
> GRANT ALL PRIVILEGES on renalware_development.* to 'renalware'@'localhost' identified by 'password';

2. Create a renalware database from the legacy schema

> rake db:create:all
> cat db/schema_v1.sql | mysql renalware -u renalware --password=password

3. Run a PHP server

We're using frog_spawn to start/stop our PHP server, try the following tasks:

> cd php/renalware
> rake php:server:start
> rake php:server:stop

You can also specifiy a root_dir and run it from the top-level app directory:

> spring rake php:server:start root_dir=php/renalware
> spring rake php:server:stop root_dir=php/renalware

You can manually run PHP if you hit problems:

> php -S localhost:8000 -t php/renalware -n

4. Login as Paul

5. Create a new user, providing initials, add all permissions

> http://localhost:8000/admin/addnewuser.php

Ruby / Rails - Setup
--------------------

1. Run `bundle`
2. Visit http://localhost:3000

TESTS
-----

1. Setup a mysql user renalware with a password

> GRANT ALL PRIVILEGES on renalware_test.* to 'renalware'@'localhost' identified by 'password';
> GRANT ALL PRIVILEGES on renalware_php_test.* to 'renalware'@'localhost' identified by 'password';

2. Run cucumber. We have profiles for tests against the legacy PHP app the sparkly new Ruby app.

Run all PHP tests:

> cucumber -p php

Run all PHP @wip tests

> cucumber -p php_wip

Run all Ruby tests

> spring cucumber

Run all Ruby @wip tests

> spring cucumber -p ruby_wip

Deployment
----------

Deployment is currently on Heroku. Get yourself a copy of the Heroku toolbelt: https://toolbelt.heroku.com

Assuming that you've got a Heroku account and are added to the app, you ought to
be able to:

> heroku login
> heroku git:remote -a renalware-dev

To deploy:
> git push heroku master
> heroku open

The app is available at http://renalware-dev.herokuapp.com. It is currently password protected:

username: renalware
password: kidney175@stones?

Advanced SSH stuff
------------------

The mysql plugin needed some extra config to setup with SSL, and to work with the
mysql2 gem. I used this config setting to get it to work:

> heroku config:set DATABASE_URL="mysql2://b494aa1f075451:632a08bf@eu-cdbr-west-01.cleardb.com/heroku_3e38e1cd9ea38b4?reconnect=true&sslca=db/cleardb/cleardb-ca.pem&sslcert=db/cleardb/b494aa1f075451-cert.pem&sslkey=db/cleardb/b494aa1f075451-key.pem"

More info:
https://www.cleardb.com/developers/ssl_connections
