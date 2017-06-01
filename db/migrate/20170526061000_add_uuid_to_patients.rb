class AddUuidToPatients < ActiveRecord::Migration[5.0]
  def change
    add_column :patients, :uuid, :uuid, default: 'uuid_generate_v4()', null: false
    add_index :patients, :uuid, using: :btree
  end
end
