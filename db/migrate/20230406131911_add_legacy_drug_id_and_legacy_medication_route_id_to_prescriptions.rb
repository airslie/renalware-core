class AddLegacyDrugIdAndLegacyMedicationRouteIdToPrescriptions < ActiveRecord::Migration[7.0]
  def change
    add_column :medication_prescriptions, :legacy_drug_id, :integer,
               comment: "Keep the previous drug id as a reference in case of issues with DMD migration"
    add_column :medication_prescriptions, :legacy_medication_route_id, :integer,
               comment: "Keep the previous route id as a reference in case of issues with DMD migration"
  end
end
