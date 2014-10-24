class CreateEncounterEvents < ActiveRecord::Migration
  def change
    create_table :encounter_events do |t|

      t.timestamps
    end
  end
end
