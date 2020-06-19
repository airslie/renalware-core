class AddUniqueIndexes < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      # Allow only one un-terminated transplant_registration_status per patient
      # Removed this for now as the way we update the terminated_on in the model
      # prevents us from enforcing this constraint atm.
      # remove_index :transplant_registration_statuses, :registration_id
      # add_index(
      #   :transplant_registration_statuses,
      #   :registration_id,
      #   unique: true,
      #   where: "terminated_on is null"
      # )

      # Allow only one current modality_modalities per patient
      # Removed until we have had a change to housekeep the duplicates
      # add_index(
      #   :modality_modalities,
      #   :patient_id,
      #   unique: true,
      #   where: "ended_on is null",
      #   name: :index_modality_modalities_on_patient_id_current
      # )

      # Removed this for now as prevents adding new profiles. Need to address holistically in
      # a separate PR
      # # An access profile must have a start date
      # change_column_null :access_profiles, :started_on, false
      # # Allow only on unterminated access profile per patient
      # add_index(
      #   :access_profiles,
      #   :patient_id,
      #   unique: true,
      #   where: "terminated_on is null",
      #   name: :index_access_profiles_on_patient_id_current
      # )

      # Allow only one transplant_registration per patient
      remove_index :transplant_registrations, :patient_id
      add_index :transplant_registrations, :patient_id, unique: true

      # Allow only one renal_profile per patient
      remove_index :renal_profiles, :patient_id
      add_index :renal_profiles, :patient_id, unique: true
    end
  end
end
