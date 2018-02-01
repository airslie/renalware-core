class CreateRefreshAllMaterializedViewsFn < ActiveRecord::Migration[5.0]
  def up
    load_function("refresh_all_matierialized_views_v01.sql")
  end

  def down
    connection.execute("DROP FUNCTION refresh_all_matierialized_views(TEXT,BOOLEAN);")
  end
end
