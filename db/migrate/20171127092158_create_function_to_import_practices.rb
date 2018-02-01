class CreateFunctionToImportPractices < ActiveRecord::Migration[5.0]
  def up
    load_function("import_practices_csv_v01.sql")
  end

  def down
    connection.execute("DROP FUNCTION IF EXISTS import_practices_csv(file text);")
  end
end
