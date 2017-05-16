class AddTemperatureToClinicVisit < ActiveRecord::Migration[5.0]
  def change
    add_column :clinic_visits, :temperature, :decimal, precision: 3, scale: 1
  end
end
