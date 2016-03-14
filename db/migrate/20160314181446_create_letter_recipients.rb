class CreateLetterRecipients < ActiveRecord::Migration
  def change
    create_table :letter_recipients do |t|
      t.string :name
      t.references :address, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_reference :letter_recipients, :letter, references: :letter_letters, index: true, null: false
    add_foreign_key :letter_recipients, :letter_letters, column: :letter_id
  end
end
