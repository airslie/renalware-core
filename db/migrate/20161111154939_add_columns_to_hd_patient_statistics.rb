class AddColumnsToHDPatientStatistics < ActiveRecord::Migration[4.2]
  def change
    add_column :hd_patient_statistics, :number_of_missed_sessions, :integer
    add_column :hd_patient_statistics, :dialysis_minutes_shortfall, :integer
    add_column :hd_patient_statistics, :dialysis_minutes_shortfall_percentage, :decimal, precision: 10, scale: 2
    add_column :hd_patient_statistics, :mean_ufr, :decimal, precision: 10, scale: 2
    add_column :hd_patient_statistics, :mean_weight_loss_as_percentage_of_body_weight, :decimal, precision: 10, scale: 2
  end
end
