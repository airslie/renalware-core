class CreateVirologyVersions < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      create_table :virology_versions do |t|
        t.string   :item_type, null: false
        t.integer  :item_id,   null: false
        t.datetime :created_at
      end
      add_index :virology_versions, [:item_type, :item_id]
    end
  end
end
