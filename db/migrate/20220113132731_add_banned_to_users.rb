class AddBannedToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :banned, :boolean, default: false, null: false
    add_column :users, :notes, :text
  end
end
