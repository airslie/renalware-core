class AddDefaultModalityDescriptionToClinicClinics < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      change_table :clinic_clinics do |t|
        t.references(
          :default_modality_description,
          foreign_key: { to_table: :modality_descriptions }
        )
      end
    end
  end
end
