class AddDoseUnitToPrescriptions < ActiveRecord::Migration
  def change
    rename_column :prescriptions, :dose, :dose_amount
    add_column :prescriptions, :dose_unit, :string, null: false
  end
end
