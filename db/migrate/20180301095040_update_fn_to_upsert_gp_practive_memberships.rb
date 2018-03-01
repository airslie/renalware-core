class UpdateFnToUpsertGPPractiveMemberships < ActiveRecord::Migration[5.1]
  def up
    load_function("import_practice_memberships_csv_v02.sql")
  end

   def down
    load_function("import_practice_memberships_csv_v01.sql")
  end
end
