/*
Finds all PG functions nag functions so that they can be displayed in an admin UI
when creating/editing system_nag_definitions
*/
SELECT
n.nspname AS schema,
p.proname AS sql_function_name
FROM
    pg_proc p
    LEFT JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE
    n.nspname NOT IN ('pg_catalog', 'information_schema')
    and n.nspname like 'renalware%'
ORDER BY
    schema,
    sql_function_name
