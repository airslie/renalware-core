class CreateLettersLetterheads < ActiveRecord::Migration
  def change
    create_table :letter_letterheads do |t|
      t.string :name, null: false
      t.string :unit_info, null: false
      t.string :trust_name, null: false
      t.string :trust_caption, null: false
      t.text :site_info_html

      t.timestamps null: false
    end
  end
end
