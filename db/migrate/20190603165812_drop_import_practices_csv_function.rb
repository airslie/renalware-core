class DropImportPracticesCSVFunction < ActiveRecord::Migration[5.2]
  def up
    within_renalware_schema do
      connection.execute("DROP FUNCTION IF EXISTS import_practices_csv(file text);")
    end
  end

  def down
    within_renalware_schema do
      load_function("import_practices_csv_v01.sql")
    end
  end
end
