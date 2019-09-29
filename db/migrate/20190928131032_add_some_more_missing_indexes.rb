class AddSomeMoreMissingIndexes < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_index :modality_descriptions, :type
      add_index :addresses, :addressable_id
      add_index :letter_recipients, :role
      # add_index :clinic_clinics, :name # this is added in heroic branch so don't add here
      add_index :pathology_requests_global_rules, :rule_set_type
      add_index :event_types, :hidden
      add_index :letter_letters, :type
      add_index :transplant_versions, :item_id
      add_index :access_profiles, :started_on
      add_index :access_profiles, :terminated_on
      add_index :hospital_units, :is_hd_site
      add_index :transplant_registration_status_descriptions, :position
    end
  end
end
