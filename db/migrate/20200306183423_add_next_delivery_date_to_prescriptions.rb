class AddNextDeliveryDateToPrescriptions < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :medication_prescriptions, :next_delivery_date, :date
    end
  end
end
