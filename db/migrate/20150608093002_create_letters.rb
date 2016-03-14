class CreateLetters < ActiveRecord::Migration
  def change
    create_table :letter_letters do |t|
      t.belongs_to :patient, index: true
      t.string :recipient_type, null: false
      t.string :state, null: false, default: 'draft'
      t.date :issued_on, null: false
      t.string :description
      t.string :salutation
      t.text :body
      t.text :notes

      t.belongs_to :created_by, index: true, null: false
      t.belongs_to :updated_by, index: true, null: false

      t.timestamps null: false
    end

    add_reference :letter_letters, :letterhead, references: :letter_letterheads, index: true, null: false
    add_foreign_key :letter_letters, :letter_letterheads, column: :letterhead_id

    add_reference :letter_letters, :author, references: :users, index: true, null: false
    add_foreign_key :letter_letters, :users, column: :author_id
  end
end
