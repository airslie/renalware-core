class AddColumnsToPatients < ActiveRecord::Migration[5.0]
  def change
    add_column :patients, :local_patient_id_2, :string, index: true
    add_column :patients, :local_patient_id_3, :string, index: true
    add_column :patients, :local_patient_id_4, :string, index: true
    add_column :patients, :local_patient_id_5, :string, index: true
    add_column :patients, :external_patient_id, :string

    add_column :patients, :local_patient_ids, :text, array: true, default: []
    add_index :patients, :local_patient_ids, using: :gin

    enable_extension "hstore"
    add_column :patients, :local_ids, :hstore
    add_index :patients, :local_ids, using: :gin
  end
end
