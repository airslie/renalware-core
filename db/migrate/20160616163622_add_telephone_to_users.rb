class AddTelephoneToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :telephone, :string
  end
end
