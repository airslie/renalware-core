Renalware v 2.0 (renal database)
============

Coming Soon...

Paul - Please drop the existing php application in the php folder, we'll sort out
database dumps separately...

SETUP
-----

If you're setting up the legacy (v1) PHP app, the following should be enough to
get going...

1. Setup a mysql user renalware with a password

> GRANT ALL PRIVILEGES on renalware.* to 'renalware'@'localhost' identified by 'password';

2. Create a renalware database from the legacy schema

> cat db/schema.sql | mysql renalware -u renalware --password=password

3. Copy the tmp/renalwareconn.php.example to tmp/renalwareconn.php and update to
reflect your settings

> cp tmp/renalwareconn.php.example tmp/renalwareconn.php

4. Run a PHP server

> php -S localhost:8000 -t php/renalware -n

5. Ask Paul to login as him

6. Create a new user, providing initials, add all permissions

> http://localhost:8000/admin/addnewuser.php