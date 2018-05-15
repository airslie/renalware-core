class AddNotesToTransplantRegistrationStatuses < ActiveRecord::Migration[5.1]
  def change
    add_column :transplant_registration_statuses, :notes, :text
  end
end
