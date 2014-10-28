class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string :nhs_number
      t.string :local_patient_id
      t.string :surname
      t.string :forename
      t.date :dob
      t.boolean :paediatric_patient_indicator
      t.string :sex
      t.string :ethnic_category
      t.integer :current_address_id
      t.integer :address_at_diagnosis_id
      t.string :gp_practice_code
      t.string :pct_org_code
      t.string :hosp_centre_code
      t.string :primary_esrf_centre
      t.timestamps
    end
  end
end
