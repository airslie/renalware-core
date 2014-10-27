class AddPatientIdToEncounterEvents < ActiveRecord::Migration
  def change
    add_column :encounter_events, :patient_id, :integer
  end
end
