class AddPageCountToLetters < ActiveRecord::Migration[5.1]
  def change
    add_column :letter_letters, :page_count, :integer
  end
end
