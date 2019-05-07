class AddDietryProteinIntakeToPETAdequacyResults < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column(
        :pd_pet_adequacy_results,
        :dietry_protein_intake,
        :decimal,
        scale: 2,
        precision: 8
      )
    end
  end
end
