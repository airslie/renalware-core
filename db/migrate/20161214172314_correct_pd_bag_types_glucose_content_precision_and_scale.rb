class CorrectPDBagTypesGlucoseContentPrecisionAndScale < ActiveRecord::Migration[4.2]
  def change
    change_column :pd_bag_types, :glucose_content, :decimal, precision: 4, scale: 2, null: false
  end
end
