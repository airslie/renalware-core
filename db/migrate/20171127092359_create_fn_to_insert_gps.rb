class CreateFnToInsertGps < ActiveRecord::Migration[5.0]
  def up
    load_function("import_gps_csv_v01.sql")
  end

  def down
    connection.execute("DROP FUNCTION IF EXISTS import_gps_csv(file text);")
  end
end
