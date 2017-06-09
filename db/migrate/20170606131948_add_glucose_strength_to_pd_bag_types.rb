class AddGlucoseStrengthToPDBagTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :pd_bag_types, :glucose_strength, :integer, null: false, default: 0
    change_column_default :pd_bag_types, :glucose_strength, nil
  end
end
