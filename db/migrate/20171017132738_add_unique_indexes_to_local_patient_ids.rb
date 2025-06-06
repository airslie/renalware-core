class AddUniqueIndexesToLocalPatientIds < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      columns = %i(
        local_patient_id
        local_patient_id_2
        local_patient_id_3
        local_patient_id_4
        local_patient_id_5
      )
      columns.each do |column|
        remove_index(:patients, column)
        add_index(:patients, column, unique: true)
      end
    end
  end
end
