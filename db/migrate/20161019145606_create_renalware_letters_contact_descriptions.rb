class CreateRenalwareLettersContactDescriptions < ActiveRecord::Migration
  def change
    create_table :letter_contact_descriptions do |t|
      t.string :system_code
      t.index :system_code, unique: true
      t.string :name
      t.index :name, unique: true
      t.integer :position
      t.index :position, unique: true

      t.timestamps null: false
    end

    add_column :letter_contacts, :description_id, :integer
    add_column :letter_contacts, :other_description, :string
    add_foreign_key :letter_contacts, :letter_contact_descriptions, column: :description_id
  end
end
