class CreateHeidiSessions < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      create_table :heidi_sessions do |t|
        t.references :patient, null: false, foreign_key: true, index: true
        t.references :user, null: false, foreign_key: true, index: true
        t.string :heidi_session_id, null: false
        t.string :heidi_patient_profile_id, null: false
        t.string :status, null: false, default: "launched"
        t.string :consult_note_status
        t.text :consult_note
        t.jsonb :raw_response, null: false, default: {}
        t.datetime :last_synced_at
        t.text :sync_error

        t.timestamps null: false
      end

      add_index :heidi_sessions, :heidi_session_id, unique: true
      add_index :heidi_sessions, %i(patient_id created_at)
      add_index :heidi_sessions, :status
    end
  end
end
