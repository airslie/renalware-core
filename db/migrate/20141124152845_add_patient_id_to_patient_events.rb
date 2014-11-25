class AddPatientIdToPatientEvents < ActiveRecord::Migration
  def change
    add_column :patient_events, :patient_id, :integer
  end
end
