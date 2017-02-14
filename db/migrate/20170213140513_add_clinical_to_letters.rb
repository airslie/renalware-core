class AddClinicalToLetters < ActiveRecord::Migration[5.0]
  def change
    add_column :letter_letters, :clinical, :boolean, null: true
  end
end
