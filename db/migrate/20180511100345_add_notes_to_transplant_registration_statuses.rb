class AddNotesToTransplantRegistrationStatuses < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_column :transplant_registration_statuses, :notes, :text
    end
  end
end
