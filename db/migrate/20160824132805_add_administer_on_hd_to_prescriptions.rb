class AddAdministerOnHDToPrescriptions < ActiveRecord::Migration
  def change
    add_column :medication_prescriptions,
               :administer_on_hd,
               :boolean,
               null: false,
               default: false
  end
end
