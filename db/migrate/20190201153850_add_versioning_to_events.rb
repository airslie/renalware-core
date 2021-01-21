class AddVersioningToEvents < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table :event_versions do |t|
        t.string   :item_type, null: false
        t.integer  :item_id,   null: false
        t.string   :event,     null: false
        t.integer  :whodunnit
        t.jsonb    :object
        t.jsonb    :object_changes
        t.datetime :created_at
      end
      add_index :event_versions, [:item_type, :item_id]
      add_index :event_versions, :whodunnit
    end
  end
end
