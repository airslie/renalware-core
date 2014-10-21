class AddColumnsToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :nhs_number, :string
    add_column :patients, :local_patient_id, :string
    add_column :patients, :surname, :string
    add_column :patients, :forename, :string
    add_column :patients, :dob, :date
    add_column :patients, :paediatric_patient_indicator, :string
    add_column :patients, :sex, :string 
    add_column :patients, :ethnic_category, :string 
  end
end
