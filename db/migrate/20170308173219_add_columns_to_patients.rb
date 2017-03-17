class AddColumnsToPatients < ActiveRecord::Migration[5.0]
  def change

    #rename_column :patients, :local_patient_id, :local_patient_id_1
    add_column :patients, :local_patient_id_2, :string
    add_column :patients, :local_patient_id_3, :string
    add_column :patients, :local_patient_id_4, :string
    add_column :patients, :local_patient_id_5, :string
    add_column :patients, :external_patient_id, :string

    add_index :patients, :local_patient_id
    add_index :patients, :local_patient_id_2
    add_index :patients, :local_patient_id_3
    add_index :patients, :local_patient_id_4
    add_index :patients, :local_patient_id_5
    add_index :patients, :external_patient_id

    add_column :patients, :local_patient_ids, :text, array: true, default: []
    add_index :patients, :local_patient_ids, using: :gin

    enable_extension "hstore"
    add_column :patients, :local_ids, :hstore
    add_index :patients, :local_ids, using: :gin
  end
end
