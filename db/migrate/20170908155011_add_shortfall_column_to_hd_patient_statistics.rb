class AddShortfallColumnToHDPatientStatistics < ActiveRecord::Migration[5.1]
  def change
    add_column :hd_patient_statistics,
               :number_of_sessions_with_dialysis_minutes_shortfall_gt_5_pct,
               :integer
  end
end
