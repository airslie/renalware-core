class AddDeletedAtToProblemNotes < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :problem_notes, :deleted_at, :datetime
      add_index :problem_notes, :deleted_at
    end
  end
end
