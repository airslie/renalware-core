class AddColumnsToPatientEthnicities < ActiveRecord::Migration[5.0]
  def change
    add_column :patient_ethnicities, :cfh_name, :string, index: true
    add_column :patient_ethnicities, :rr18_code, :string
  end
end
