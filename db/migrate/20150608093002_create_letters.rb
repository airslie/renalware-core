class CreateLetters < ActiveRecord::Migration
  def change
    create_table :letter_letters do |t|
      t.string :state, null: false, default: 'draft'
      t.string :type, index: true, null: false, default: 'Letter'
      t.text :problems
      t.text :medications
      t.text :body
      t.string :signature
      t.string :recipient, null: false, default: 'doctor'
      t.string :additional_recipients
      t.belongs_to :doctor, index: true
      t.belongs_to :patient, index: true
      t.belongs_to :clinic_visit, index: true
      t.timestamps null: false
    end

    add_reference :letter_letters, :description, references: :letter_descriptions, index: true
    add_foreign_key :letter_letters, :letter_descriptions, column: :description_id

    add_reference :letter_letters, :author, references: :users, index: true
    add_foreign_key :letter_letters, :users, column: :author_id

    add_reference :letter_letters, :reviewer, references: :users, index: true
    add_foreign_key :letter_letters, :users, column: :reviewer_id

    add_reference :letter_letters, :recipient_address, references: :addresses, index: true
    add_foreign_key :letter_letters, :addresses, column: :recipient_address_id
  end
end
