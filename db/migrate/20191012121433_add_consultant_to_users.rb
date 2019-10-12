class AddConsultantToUsers < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :users, :consultant, :boolean, default: false, null: false, index: true
    end
  end
end
