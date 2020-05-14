class ModifyPDPETResultsForDextrose < ActiveRecord::Migration[6.0]
  def change
    remove_column :pd_pet_results, :dextrose, :integer
    add_reference(
      :pd_pet_results,
      :dextrose_concentration,
      foreign_key: { to_table: :pd_pet_dextrose_concentrations },
      index: true,
      null: true
    )
  end
end
