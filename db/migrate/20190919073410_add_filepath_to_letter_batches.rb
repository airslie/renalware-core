class AddFilepathToLetterBatches < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :letter_batches, :filepath, :string
    end
  end
end
