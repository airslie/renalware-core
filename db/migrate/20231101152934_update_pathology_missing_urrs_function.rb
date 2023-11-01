class UpdatePathologyMissingUrrsFunction < ActiveRecord::Migration[7.0]
  def up
    within_renalware_schema do
      load_function("pathology_missing_urrs_v02.sql")
    end
  end

  def down
    within_renalware_schema do
      load_function("pathology_missing_urrs_v01.sql")
    end
  end
end
