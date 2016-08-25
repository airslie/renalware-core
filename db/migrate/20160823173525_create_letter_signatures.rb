class CreateLetterSignatures < ActiveRecord::Migration
  def change
    create_table :letter_signatures do |t|
      t.datetime :signed_at, null: false

      t.timestamps null: false
    end

    add_reference :letter_signatures, :letter, references: :letter_letters, index: true, null: false
    add_foreign_key :letter_signatures, :letter_letters, column: :letter_id

    add_reference :letter_signatures, :user, references: :users, index: true, null: false
    add_foreign_key :letter_signatures, :users, column: :user_id
  end
end
