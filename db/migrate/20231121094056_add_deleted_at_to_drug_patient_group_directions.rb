class AddDeletedAtToDrugPatientGroupDirections < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      within_renalware_schema do
        add_column :drug_patient_group_directions, :deleted_at, :datetime
        remove_index :drug_patient_group_directions, :code
        add_index(
          :drug_patient_group_directions,
          :code,
          unique: true,
          where: "ends_on is null and deleted_at is null"
        )
      end
    end
  end
end
