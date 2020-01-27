class CreatePathologyVersions < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table :pathology_versions do |t|
        t.string   :item_type, null: false
        t.integer  :item_id,   null: false
        t.string   :event,     null: false
        t.string   :whodunnit
        t.jsonb    :object
        t.jsonb    :object_changes
        t.datetime :created_at
      end
      add_index :pathology_versions, [:item_type, :item_id]
    end
  end
end
