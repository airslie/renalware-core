class AddLastHomeDeliveryDateToPrescriptions < ActiveRecord::Migration[5.0]
  def change
    add_column :medication_prescriptions, :last_delivery_date, :date
  end
end
