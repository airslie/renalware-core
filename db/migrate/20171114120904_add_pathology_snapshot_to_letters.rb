class AddPathologySnapshotToLetters < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_column :letter_letters, :pathology_timestamp, :datetime
    end
  end
end
