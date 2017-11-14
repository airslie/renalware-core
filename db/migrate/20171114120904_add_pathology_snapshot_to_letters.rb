class AddPathologySnapshotToLetters < ActiveRecord::Migration[5.1]
  def change
    add_column :letter_letters, :pathology_snapshot, :jsonb
    add_column :letter_letters, :pathology_snapshot_updated_at, :datetime
  end
end
