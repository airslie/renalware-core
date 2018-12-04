class AddMissingForeignKeyIndexes < ActiveRecord::Migration[5.1]
  # Found using https://github.com/gregnavis/active_record_doctor
  def change
    within_renalware_schema do
      add_index :drug_types_drugs, :drug_type_id
      add_index :hd_stations, :location_id
      add_index :letter_contacts, :patient_id
      add_index :messaging_messages, :replying_to_message_id
      add_index :pathology_observation_descriptions, :measurement_unit_id
      add_index :patient_bookmarks, :user_id
      add_index(
        :pd_peritonitis_episode_types, :peritonitis_episode_type_description_id,
        name: "index_pd_peritonitis_episode_types_description_id"
      )
      add_index :pd_pet_adequacy_results, :patient_id
      add_index :roles_users, :role_id
    end
  end
end
