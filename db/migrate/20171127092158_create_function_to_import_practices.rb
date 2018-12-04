class CreateFunctionToImportPractices < ActiveRecord::Migration[5.0]
  def up
    within_renalware_schema do
      load_function("import_practices_csv_v01.sql")
    end
  end

  def down
    within_renalware_schema do
      connection.execute("DROP FUNCTION IF EXISTS import_practices_csv(file text);")
    end
  end
end
