class AddStateTrackingColsToLetters < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_column :letter_letters, :submitted_for_approval_at, :datetime
      add_reference :letter_letters,
                    :submitted_for_approval_by,
                    foreign_key: { to_table: :users },
                    index: true
      add_column :letter_letters, :approved_at, :datetime
      add_reference :letter_letters,
                    :approved_by,
                    foreign_key: { to_table: :users },
                    index: true
      add_column :letter_letters, :completed_at, :datetime
      add_reference :letter_letters,
                    :completed_by,
                    foreign_key: { to_table: :users },
                    index: true
    end
  end
end
