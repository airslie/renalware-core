CREATE
OR REPLACE FUNCTION audit_view_as_json(view_name text)
/*
 Converts the specified view into its json representation suitable for example
 for creating a historical snapshot.
 Example usage:
 select audit_view_as_json('reporting_bone_audit')
 TC 1.11.2017
 */
RETURNS json LANGUAGE 'plpgsql' as $$ DECLARE result json;

BEGIN EXECUTE format(
  '
  select row_to_json(t)
    from (
      select
        current_timestamp as runat,
        (select array_to_json(array_agg(row_to_json(d))
      )
    from (select * from %s) d) as data) t;
    ',
  quote_ident(view_name)
) into result;

return result;

END $$;
