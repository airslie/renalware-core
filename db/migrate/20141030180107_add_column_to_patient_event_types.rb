class AddColumnToPatientEventTypes < ActiveRecord::Migration
  def change
    add_column :patient_event_types, :name, :string
  end
end
