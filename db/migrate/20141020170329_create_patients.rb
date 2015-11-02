class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string :nhs_number
      t.string :local_patient_id
      t.string :family_name
      t.string :given_name
      t.date :born_on
      t.boolean :paediatric_patient_indicator
      t.string :sex
      t.integer :ethnicity_id
      t.integer :current_address_id
      t.integer :address_at_diagnosis_id
      t.string :gp_practice_code
      t.string :pct_org_code
      t.string :hosp_centre_code
      t.string :primary_esrf_centre
      t.date :died_on
      t.integer :first_edta_code_id
      t.integer :second_edta_code_id
      t.text :death_details
      t.timestamps
    end
  end
end
