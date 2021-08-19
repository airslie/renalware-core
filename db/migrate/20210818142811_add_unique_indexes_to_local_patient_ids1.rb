class AddUniqueIndexesToLocalPatientIds1 < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      %i(
        local_patient_id
        local_patient_id_2
        local_patient_id_3
        local_patient_id_4
        local_patient_id_5
      ).each do |col|
        # Drop the existing index and add a new unique one
        remove_index(:patients, col)
        add_index(:patients, col, unique: true)
      end
    end
  end
end
