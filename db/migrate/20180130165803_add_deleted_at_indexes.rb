class AddDeletedAtIndexes < ActiveRecord::Migration[5.1]
  def change
    add_index :research_studies, :deleted_at
    add_index :research_study_participants, :deleted_at
    add_index :admission_consults, :deleted_at
    add_index :clinical_allergies, :deleted_at
    add_index :patient_alerts, :deleted_at
    add_index :access_plan_types, :deleted_at
    add_index :drugs, :deleted_at
    add_index :event_types, :deleted_at
    add_index :hd_cannulation_types, :deleted_at
    add_index :modality_descriptions, :deleted_at
    add_index :pd_systems, :deleted_at
    add_index :hd_profiles, :deactivated_at
  end
end
