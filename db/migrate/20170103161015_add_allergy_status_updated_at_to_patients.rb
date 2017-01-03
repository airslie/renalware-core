class AddAllergyStatusUpdatedAtToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :allergy_status_updated_at, :datetime, null: true
  end
end
