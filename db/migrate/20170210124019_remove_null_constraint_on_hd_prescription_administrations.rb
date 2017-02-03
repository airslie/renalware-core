class RemoveNullConstraintOnHDPrescriptionAdministrations < ActiveRecord::Migration[5.0]
  def change
    change_column :hd_prescription_administrations, :administered, :boolean, null: true
  end
end
