class MakePaediatricPatientIndicatorBoolean < ActiveRecord::Migration
  def change
    change_column :patients, :paediatric_patient_indicator, :boolean
  end
end
