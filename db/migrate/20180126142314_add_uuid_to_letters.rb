class AddUuidToLetters < ActiveRecord::Migration[5.1]
  def change
    add_column :letter_letters, :uuid, :uuid, default: "uuid_generate_v4()", null: false
    add_index :letter_letters, :uuid, using: :btree
  end
end
