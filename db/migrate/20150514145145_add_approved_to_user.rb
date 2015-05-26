class AddApprovedToUser < ActiveRecord::Migration
  def change
    add_column :users, :approved, :boolean, default: false
    add_index  :users, :approved
  end
end
