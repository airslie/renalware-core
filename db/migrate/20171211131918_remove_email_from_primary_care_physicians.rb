class RemoveEmailFromPrimaryCarePhysicians < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      remove_column :patient_primary_care_physicians,
                    :email,
                    :string
    end
  end
end
