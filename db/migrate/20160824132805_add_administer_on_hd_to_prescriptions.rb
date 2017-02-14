class AddAdministerOnHDToPrescriptions < ActiveRecord::Migration[4.2]
  def change
    add_column :medication_prescriptions,
               :administer_on_hd,
               :boolean,
               null: false,
               default: false
  end
end
