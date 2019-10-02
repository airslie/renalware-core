class CreateHDSessionFormBatches < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table :hd_session_form_batches do |t|
        t.integer :status, null: false, default: 0, index: true
        t.jsonb :query_params, default: {}, null: false
        t.references :created_by, foreign_key: { to_table: :users }, index: true, null: false
        t.references :updated_by, foreign_key: { to_table: :users }, index: true, null: false
        t.string :filepath
        t.string :last_error
        t.integer :batch_items_count
        t.timestamps null: false
      end
    end
  end
end
