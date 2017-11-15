class AddPathologySnapshotToLetters < ActiveRecord::Migration[5.1]
  def change
    add_column :letter_letters, :pathology_timestamp, :datetime
  end
end
