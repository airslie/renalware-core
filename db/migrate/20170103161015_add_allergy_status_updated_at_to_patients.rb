class AddAllergyStatusUpdatedAtToPatients < ActiveRecord::Migration[4.2]
  def change
    add_column :patients, :allergy_status_updated_at, :datetime, null: true
  end
end
