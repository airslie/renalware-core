class AddColumnsToEncounterEvents < ActiveRecord::Migration
  def change
    add_column :encounter_events, :enc_date, :date
    add_column :encounter_events, :staff_name, :string
    add_column :encounter_events, :enc_type, :string
    add_column :encounter_events, :enc_descript, :string
    add_column :encounter_events, :enc_notes, :text
  end
end
