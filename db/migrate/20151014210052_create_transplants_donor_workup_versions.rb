class CreateTransplantsDonorWorkupVersions < ActiveRecord::Migration
  def change
    create_table :transplants_donor_workup_versions do |t|
      t.string   :item_type, :null => false
      t.integer  :item_id,   :null => false
      t.string   :event,     :null => false
      t.string   :whodunnit
      t.jsonb    :object
      t.jsonb    :object_changes
      t.datetime :created_at
    end
    add_index :transplants_donor_workup_versions, [:item_type, :item_id], name: 'donor_workup_versions_type_id'
  end
end
