class CreateHDDialysates < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      create_table :hd_dialysates do |t|
        t.string :name, null: false
        t.text :description
        t.integer :sodium_content, null: false
        t.string :sodium_content_uom, null: false

        t.datetime :deleted_at, index: true
        t.timestamps null: false
      end
    end
  end
end
