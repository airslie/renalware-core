class CreateRenalVersions < ActiveRecord::Migration[5.1]
  def change
    create_table :renal_versions do |t|
      t.string   :item_type, :null => false
      t.integer  :item_id,   :null => false
      t.string   :event,     :null => false
      t.string   :whodunnit
      t.jsonb    :object
      t.jsonb    :object_changes
      t.datetime :created_at
    end
    add_index :renal_versions, [:item_type, :item_id]
  end
end
