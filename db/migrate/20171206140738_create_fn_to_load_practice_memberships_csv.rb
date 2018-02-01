class CreateFnToLoadPracticeMembershipsCSV < ActiveRecord::Migration[5.1]
  def up
    load_function("import_practice_memberships_csv_v01.sql")
  end

   def down
    connection.execute(
      "DROP FUNCTION IF EXISTS import_practice_memberships_csv(file text);"
    )
  end
end
