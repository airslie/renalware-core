Renalware v 2.0 (renal database)
============

Coming Soon...

SETUP
-----

If you're setting up the legacy (v1) PHP app, the following should be enough to get going...

1. Setup a mysql user renalware with a password

> GRANT ALL PRIVILEGES on renalware.* to 'renalware'@'localhost' identified by 'password';

2. Create a renalware database from the legacy schema

> cat db/schema.sql | mysql renalware -u renalware --password=password

3. Run a PHP server

> php -S localhost:8000 -t php/renalware -n

4. Ask Paul to login as him

5. Create a new user, providing initials, add all permissions

> http://localhost:8000/admin/addnewuser.php

TESTS
-----

1. Setup a mysql user renalware with a password

> GRANT ALL PRIVILEGES on renalware_test.* to 'renalware'@'localhost' identified by 'password';

2. Run cucumber. We have profiles for tests against the legacy PHP app the sparkly new Ruby app.

Run all PHP tests:

> cucumber
> cucumber -p php

Run all PHP @wip tests

> cucumber -p php_wip

Run all Ruby tests

> cucumber -p ruby

Run all Ruby @wip tests

> cucumber -p ruby_wip