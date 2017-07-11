/*
Return any materialized view of function starting with reporting_, and argument names if a function.
This lets us display a list of data sources when defining an audit in the UI, and knowowing the names(s)
of funtion arguments lets us argument grab the corresponding data (from Rails' params) and pass them in
when invoking the argument (used for example in drill down audits.
Note this is not a materiralized view like all the other reporting views.

Replace the fn type definitions and spaces in the arguments list so e.g.
"x integer, y TEXT" becomes "x,y"
Use a global and case insensitive regex
*/
SELECT  p.proname as name,
  regexp_replace(pg_catalog.pg_get_function_identity_arguments(p.oid), 'boolean|text|integer|date|timestamp|uuid|[ ]', '', 'gi')
  FROM   (SELECT oid, * FROM pg_proc p WHERE NOT p.proisagg) p
  where p.proname ~ '^reporting_'
UNION
SELECT  oid::regclass::text, NULL FROM pg_class WHERE relkind = 'm' AND relname ~ '^reporting_'
