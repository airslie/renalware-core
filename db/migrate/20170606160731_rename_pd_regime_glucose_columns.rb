class RenamePDRegimeGlucoseColumns < ActiveRecord::Migration[5.0]
  def change
    rename_column :pd_regimes, :glucose_volume_percent_1_36, :glucose_volume_low_strength
    rename_column :pd_regimes, :glucose_volume_percent_2_27, :glucose_volume_medium_strength
    rename_column :pd_regimes, :glucose_volume_percent_3_86, :glucose_volume_high_strength
  end
end
