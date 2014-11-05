class AddDeleteColumnToPatientEventTypes < ActiveRecord::Migration
  def change
    add_column :patient_event_types, :deleted_at, :datetime
  end
end
