class AddColumnsToPatients < ActiveRecord::Migration[5.0]
  def change
    add_column :patients, :local_patient_id_2, :string, index: true
    add_column :patients, :local_patient_id_3, :string, index: true
    add_column :patients, :local_patient_id_4, :string, index: true
    add_column :patients, :local_patient_id_5, :string, index: true
    add_column :patients, :external_patient_id, :string
  end
end
