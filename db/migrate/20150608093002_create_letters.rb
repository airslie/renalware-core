class CreateLetters < ActiveRecord::Migration
  def change
    create_table :letters do |t|
      t.string :state, null: false, default: 'draft'
      t.string :type, index: true, null: false, default: 'ClinicLetter'
      t.belongs_to :letter_description, null: false, index: true
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

    add_reference :letters, :author, references: :users, index: true
    add_foreign_key :letters, :users, column: :author_id
    add_reference :letters, :reviewer, references: :users, index: true
    add_foreign_key :letters, :users, column: :reviewer_id
    add_reference :letters, :recipient_address, references: :addresses, index: true
    add_foreign_key :letters, :addresses, column: :recipient_address_id
  end
end
