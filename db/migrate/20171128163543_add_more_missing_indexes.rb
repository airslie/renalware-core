class AddMoreMissingIndexes < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_index :pathology_observations, :observed_at # maybe add result also
      add_index :pathology_observation_descriptions, :code
      add_index :pathology_observation_requests, :requested_at
      add_index :pathology_requests_drug_categories, :name
      add_index :patient_bookmarks, :deleted_at
      add_index :users, :family_name # helps uniqueness validation
      add_index :users, :given_name # helps uniqueness validation
      add_index :users, :signature
      add_index :roles, :name # helps uniqueness validation
      add_index :hd_sessions, :type
      add_index :hd_sessions, :signed_off_at
      add_index :hd_sessions, :performed_on
    end
  end
end
