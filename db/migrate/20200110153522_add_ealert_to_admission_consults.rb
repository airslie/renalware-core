class AddEalertToAdmissionConsults < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :admission_consults, :e_alert, :boolean, null: false, default: false
    end
  end
end
