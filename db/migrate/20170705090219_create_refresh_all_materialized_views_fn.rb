class CreateRefreshAllMaterializedViewsFn < ActiveRecord::Migration[5.0]
  def up
    # Function to refresh all materialized views in all or a specified schema,
    # optionally concurrently
    # From https://github.com/frankhommers/RefreshAllMaterializedViews
    sql = <<-SQL.squish
      CREATE OR REPLACE FUNCTION
      refresh_all_matierialized_views(_schema TEXT DEFAULT '*', _concurrently BOOLEAN DEFAULT false)
      RETURNS INT AS $$
        DECLARE
          r RECORD;
        BEGIN
          RAISE NOTICE 'Refreshing materialized view(s) in % %',
            CASE WHEN _schema = '*' THEN 'all schemas'
            ELSE 'schema "'|| _schema || '"'
            END,
            CASE WHEN _concurrently
            THEN 'concurrently'
            ELSE '' END;
          IF pg_is_in_recovery() THEN
            RETURN 0;
          ELSE
            FOR r IN SELECT schemaname,
                            matviewname FROM pg_matviews WHERE schemaname = _schema OR _schema = '*'
            LOOP
              RAISE NOTICE 'Refreshing materialized view "%"."%"', r.schemaname, r.matviewname;
              EXECUTE 'REFRESH MATERIALIZED VIEW ' || CASE WHEN _concurrently THEN 'CONCURRENTLY '
              ELSE '' END || '"' || r.schemaname || '"."' || r.matviewname || '"';
            END LOOP;
          END IF;
          RETURN 1;
        END
      $$ LANGUAGE plpgsql;
    SQL

    ActiveRecord::Base.connection.execute(sql)
  end

  def down
    ActiveRecord::Base.connection.execute(
      "DROP FUNCTION refresh_all_matierialized_views(TEXT,BOOLEAN);"
    )
  end
end
