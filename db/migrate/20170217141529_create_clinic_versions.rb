class CreateClinicVersions < ActiveRecord::Migration[5.0]
  def change
    create_table :clinic_versions do |t|
      t.string   :item_type, :null => false
      t.integer  :item_id,   :null => false
      t.string   :event,     :null => false
      t.string   :whodunnit
      t.jsonb    :object
      t.jsonb    :object_changes
      t.datetime :created_at
    end
    add_index :clinic_versions,
              [:item_type, :item_id],
              name: "clinic_versions_type_id"
  end
end
