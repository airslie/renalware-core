class AddAddressKeysToPatient < ActiveRecord::Migration
  def change
    add_column :patients, :current_address_id, :integer
    add_column :patients, :address_at_diagnosis_id, :integer
  end
end
