class AddRrCodeToMedicationRoutes < ActiveRecord::Migration[5.1]
  def change
    add_column :medication_routes, :rr_code, :string
  end
end
