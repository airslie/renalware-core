class CreateAddressVersions < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      create_table :address_versions do |t|
        t.string   :item_type, null: false
        t.integer  :item_id,   null: false
        t.string   :event,     null: false
        t.string   :whodunnit
        t.jsonb    :object
        t.jsonb    :object_changes
        t.datetime :created_at
      end
      add_index :address_versions, [:item_type, :item_id]
    end
  end
end
