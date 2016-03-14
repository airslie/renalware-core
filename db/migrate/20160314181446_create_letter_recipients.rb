class CreateLetterRecipients < ActiveRecord::Migration
  def change
    create_table :letter_recipients do |t|
      t.string :source_type
      t.integer :source_id
      t.string :name

      t.timestamps null: false
    end

    add_reference :letter_recipients, :letter, references: :letter_letters, index: true, null: false
    add_foreign_key :letter_recipients, :letter_letters, column: :letter_id

    add_index :letter_recipients, [:source_type, :source_id]
  end
end
