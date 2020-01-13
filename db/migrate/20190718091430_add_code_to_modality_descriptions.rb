class AddCodeToModalityDescriptions < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :modality_descriptions, :code, :string
      add_index :modality_descriptions, :code, unique: true
    end
  end
end
