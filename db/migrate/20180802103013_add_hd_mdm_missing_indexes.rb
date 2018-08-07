class AddHDMDMMissingIndexes < ActiveRecord::Migration[5.1]
  def change
    add_index :modality_modalities, :ended_on
    add_index :modality_descriptions, :name
    add_index :transplant_registration_statuses, :terminated_on
    add_index :transplant_registration_statuses, :started_on
  end
end
