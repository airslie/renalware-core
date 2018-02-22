class AddStateIndexOnModalities < ActiveRecord::Migration[5.1]
  def change
    add_index :modality_modalities, :state
  end
end
