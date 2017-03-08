class AddIndicesToPatients < ActiveRecord::Migration[5.0]
  def change
    add_index :patients, :local_patient_id_2
    add_index :patients, :local_patient_id_3
    add_index :patients, :local_patient_id_4
    add_index :patients, :local_patient_id_5
  end
end
