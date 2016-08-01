class CreateLetterArchives < ActiveRecord::Migration
  def change
    create_table :letter_archives do |t|
      t.text :content, null: false
      t.belongs_to :created_by, index: true, null: false
      t.belongs_to :updated_by, index: true

      t.timestamps null: false
    end

    add_reference :letter_archives, :letter, references: :letter_letters, index: true, null: false
    add_foreign_key :letter_archives, :letter_letters, column: :letter_id
  end
end
