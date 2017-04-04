class AddEnclosuresToLetters < ActiveRecord::Migration[5.0]
  def change
    add_column :letter_letters, :enclosures, :string
  end
end
