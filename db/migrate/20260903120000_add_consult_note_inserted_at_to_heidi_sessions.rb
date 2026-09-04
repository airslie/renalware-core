class AddConsultNoteInsertedAtToHeidiSessions < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      add_column :heidi_sessions, :consult_note_inserted_at, :datetime
    end
  end
end
