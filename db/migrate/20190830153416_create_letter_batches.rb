class CreateLetterBatches < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table :letter_batches do |t|
        t.integer :status, null: false, default: 0, index: true
        t.jsonb :query_params, default: {}, null: false
        t.references :created_by, foreign_key: { to_table: :users }, index: true, null: false
        t.references :updated_by, foreign_key: { to_table: :users }, index: true, null: false
        t.integer :batch_items_count
        t.timestamps null: false
      end
    end
  end
end
