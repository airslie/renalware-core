class AddNameToAddress < ActiveRecord::Migration[4.2]
  def change
    add_column :addresses, :name, :string
  end
end
