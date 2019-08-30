# rubocop:disable Rails/CreateTableWithTimestamps
class CreateLetterBatchItems < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table :letter_batch_items do |t|
        t.references :letter, foreign_key: { to_table: :letter_letters }, null: false, index: false
        t.references :batch, foreign_key: { to_table: :letter_batches }, null: false, index: false
      end
      add_index :letter_batch_items, [:letter_id, :batch_id], unique: true
    end
  end
end
# rubocop:enable Rails/CreateTableWithTimestamps
