class AddPositionToLetterDescriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :letter_descriptions, :position, :integer, default: 0, null: false, index: true
  end
end
