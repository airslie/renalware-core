class UpdateImportPracticeMembershipsCSV < ActiveRecord::Migration[5.2]
  def up
    within_renalware_schema do
      load_function("import_practice_memberships_csv_v03.sql")
    end
  end

  def down
    within_renalware_schema do
      load_function("import_practice_memberships_csv_v02.sql")
    end
  end
end
