class CreatePatientsMasterIndex < ActiveRecord::Migration[5.2]
  def change
    create_table :patient_master_index do |t|
      t.references :patient, null: true, foreign_key: true
      t.string :nhs_number, index: true
      t.string :hospital_number, index: true
      t.string :title
      t.string :family_name
      t.string :middle_name
      t.string :given_name
      t.string :suffix
      t.string :sex
      t.date :born_on
      t.datetime :died_at
      t.string :ethnicity
      t.string :practice_code
      t.string :gp_code
      t.timestamps null: false
    end

    add_index :patient_master_index, [:family_name, :given_name]
  end
end
