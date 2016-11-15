class RemoveUnitsFromAttributeNames < ActiveRecord::Migration
  def change
    rename_column(:pd_bag_types, :glucose_grams_per_litre, :glucose_content)
    rename_column(:pd_bag_types, :sodium_mmole_l, :sodium_content)
    rename_column(:pd_bag_types, :lactate_mmole_l, :lactate_content)
    rename_column(:pd_bag_types, :bicarbonate_mmole_l, :bicarbonate_content)
    rename_column(:pd_bag_types, :calcium_mmole_l, :calcium_content)
    rename_column(:pd_bag_types, :magnesium_mmole_l, :magnesium_content)

    rename_column(:pd_regimes, :glucose_ml_percent_1_36, :glucose_volume_percent_1_36)
    rename_column(:pd_regimes, :glucose_ml_percent_2_27, :glucose_volume_percent_2_27)
    rename_column(:pd_regimes, :glucose_ml_percent_3_86, :glucose_volume_percent_3_86)
    rename_column(:pd_regimes, :amino_acid_ml, :amino_acid_volume)
    rename_column(:pd_regimes, :icodextrin_ml, :icodextrin_volume)
    rename_column(:pd_regimes, :overnight_pd_ml, :overnight_pd_volume)
    rename_column(:pd_regimes, :last_fill_ml, :last_fill_volume)
  end
end
