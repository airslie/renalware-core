class AddPatientEventTypeIdToPatientEvent < ActiveRecord::Migration
  def change
    add_column :patient_events, :patient_event_type_id, :integer
    remove_column :patient_events, :patient_event_type, :string
  end
end
