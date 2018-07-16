class AddHiddenToModalityDescriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :modality_descriptions, :hidden, :boolean, default: false, null: false
  end
end
