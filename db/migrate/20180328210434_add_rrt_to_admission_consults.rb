class AddRrtToAdmissionConsults < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_column :admission_consults, :rrt, :boolean, default: false, null: false
    end
  end
end
