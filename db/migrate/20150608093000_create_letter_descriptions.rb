class CreateLetterDescriptions < ActiveRecord::Migration[4.2]
  def change
    create_table :letter_descriptions do |t|
      t.string :text, null: false
      t.timestamps null: false
    end
  end
end
