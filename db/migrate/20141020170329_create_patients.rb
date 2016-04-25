class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string :nhs_number
      t.string :local_patient_id, null: false
      t.string :family_name,      null: false
      t.string :given_name,       null: false
      t.date :born_on,            null: false
      t.boolean :paediatric_patient_indicator
      t.string :sex
      t.references :ethnicity,    foreign_key: true
      t.integer :current_address_id
      t.integer :address_at_diagnosis_id
      t.string :gp_practice_code
      t.string :pct_org_code
      t.string :hospital_centre_code
      t.string :primary_esrf_centre
      t.date :died_on
      t.integer :first_edta_code_id
      t.integer :second_edta_code_id
      t.text :death_notes
      t.boolean :cc_on_all_letters, default: true
      t.timestamps
    end
  end
end
