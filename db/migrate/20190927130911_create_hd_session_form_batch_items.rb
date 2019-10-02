# rubocop:disable Rails/CreateTableWithTimestamps
class CreateHDSessionFormBatchItems < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table :hd_session_form_batch_items do |t|
        t.references :batch, foreign_key: { to_table: :hd_session_form_batches }, null: false, index: false
        # As a precurosr to combining letter batches and session form batches into one table
        # eg print_batches, use a generic reference here to something printable, rather than a
        # t.references :patient etc
        t.integer :printable_id, null: false, index: false
        t.integer(:status, default: 0, null: false, limit: 2, index: true) # smallint
      end
      add_index :hd_session_form_batch_items, [:batch_id, :printable_id], unique: true
    end
  end
end
# rubocop:enable Rails/CreateTableWithTimestamps
