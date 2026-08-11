class CreateTransplantNHSBTWaitListUploads < ActiveRecord::Migration[8.1]
  def change
    within_renalware_schema do
      create_table :transplant_nhsbt_wait_list_uploads do |t|
        t.references :created_by, null: false, foreign_key: { to_table: :users }, type: :integer
        t.references :updated_by, null: false, foreign_key: { to_table: :users }, type: :integer
        t.string :filename, null: false
        t.integer :status, null: false, default: 0
        t.integer :matched_count, null: false, default: 0
        t.integer :unmatched_count, null: false, default: 0
        t.integer :imported_count, null: false, default: 0
        t.jsonb :rows, null: false, default: []
        t.datetime :imported_at
        t.timestamps
      end
    end
  end
end
