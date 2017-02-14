class CreateRenalwareLettersContactDescriptions < ActiveRecord::Migration[4.2]
  def change
    create_table :letter_contact_descriptions do |t|
      t.string :system_code, null: false
      t.index :system_code, unique: true
      t.string :name, null: false
      t.index :name, unique: true
      t.integer :position, null: false
      t.index :position, unique: true

      t.timestamps null: false
    end

    add_column :letter_contacts, :description_id, :integer, null: false
    add_column :letter_contacts, :other_description, :string
    add_foreign_key :letter_contacts, :letter_contact_descriptions, column: :description_id
  end
end
