class CreateFnToLoadPracticeMembershipsCSV < ActiveRecord::Migration[5.1]
  def up
    within_renalware_schema do
      load_function("import_practice_memberships_csv_v01.sql")
    end
  end

  def down
    within_renalware_schema do
      connection.execute(
        "DROP FUNCTION IF EXISTS import_practice_memberships_csv(file text);"
      )
    end
  end
end
