class AddShortfallColumnToHDPatientStatistics < ActiveRecord::Migration[5.1]
  def change
    add_column :hd_patient_statistics, :has_shortfall_gt_5_pct, :integer
  end
end
