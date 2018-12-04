class AddStateIndexOnModalities < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_index :modality_modalities, :state
    end
  end
end
