class AddUKRDCHelperColumnToPatients < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :patients, :checked_for_ukrdc_changes_at, :datetime
    end
  end
end
