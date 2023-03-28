class AddInactiveToDrugs < ActiveRecord::Migration[6.0]
  def change
    add_column :drugs, :inactive, :boolean, default: false
  end
end
