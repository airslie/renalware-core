class CreatePatientEventTypes < ActiveRecord::Migration
  def change
    create_table :patient_event_types do |t|

      t.timestamps
    end
  end
end
