class CreateLetterDescriptions < ActiveRecord::Migration
  def change
    create_table :letter_descriptions do |t|
      t.string :text, null: false
      t.timestamps null: false
    end
  end
end
