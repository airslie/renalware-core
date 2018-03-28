class AddRrtToAdmissionConsults < ActiveRecord::Migration[5.1]
  def change
    add_column :admission_consults, :rrt, :boolean, default: false, null: false
  end
end
