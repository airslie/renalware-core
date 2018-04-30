class AddUniqueConstraintsOnPatientLocalIds < ActiveRecord::Migration[5.1]
  def change
    remove_index :patients, :local_patient_id
    remove_index :patients, :local_patient_id_2
    remove_index :patients, :local_patient_id_3
    remove_index :patients, :local_patient_id_4
    remove_index :patients, :local_patient_id_5

    add_index :patients, :nhs_number, unique: true
    add_index :patients, :local_patient_id, unique: true
    add_index :patients, :local_patient_id_2, unique: true
    add_index :patients, :local_patient_id_3, unique: true
    add_index :patients, :local_patient_id_4, unique: true
    add_index :patients, :local_patient_id_5, unique: true
  end
end
