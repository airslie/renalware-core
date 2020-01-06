class AddNextOfKinToPatients < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :patients, :next_of_kin, :text
    end
  end
end
