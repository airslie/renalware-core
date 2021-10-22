class AddDeletedAtToLetterDescriptions < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :letter_descriptions, :deleted_at, :datetime
      add_index :letter_descriptions, :deleted_at
    end
  end
end
