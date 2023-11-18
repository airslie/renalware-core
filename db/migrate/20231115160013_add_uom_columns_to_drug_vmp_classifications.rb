class AddUomColumnsToDrugVMPClassifications < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      add_reference(
        :drug_vmp_classifications,
        :unit_dose_uom,
        references: :drug_unit_of_measures,
        index: true
      )

      add_reference(
        :drug_vmp_classifications,
        :unit_dose_form_size_uom,
        references: :drug_unit_of_measures,
        index: true
      )

      add_reference(
        :drug_vmp_classifications,
        :active_ingredient_strength_numerator_uom,
        references: :drug_unit_of_measures,
        index: { name: "index_drug_vmp_classifications_on_active_ing_st_num_uom_id" }
      )
    end
  end
end
