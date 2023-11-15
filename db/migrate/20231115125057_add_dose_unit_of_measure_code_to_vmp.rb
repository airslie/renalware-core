class AddDoseUnitOfMeasureCodeToVMP < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      add_column(
        :drug_dmd_virtual_medical_products,
        :unit_dose_uom_code,
        :string,
        comment: "dm+d name VMP.UNIT_DOSE_UOMCD"
      )

      add_column(
        :drug_dmd_virtual_medical_products,
        :unit_dose_form_size_uom_code,
        :string,
        comment: "dm+d name VMP.UDFS_UOMCD"
      )

      add_column(
        :drug_dmd_virtual_medical_products,
        :active_ingredient_strength_numerator_uom_code,
        :string,
        comment: "dm+d name VMP.STRNT_NMRTR_UOMCD"
      )
    end
  end
end
