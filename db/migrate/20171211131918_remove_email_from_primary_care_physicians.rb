class RemoveEmailFromPrimaryCarePhysicians < ActiveRecord::Migration[5.1]
  def change
    remove_column :patient_primary_care_physicians,
                  :email,
                  :string
  end
end
