class CreatePatientEvents < ActiveRecord::Migration
  def change
    create_table :patient_events do |t|
      t.datetime :date_time
      t.string :user_id
      t.string :patient_event_type
      t.string :description
      t.text :notes
      t.timestamps
    end
  end
end
