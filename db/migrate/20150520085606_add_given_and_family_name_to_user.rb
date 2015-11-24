class AddGivenAndFamilyNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :given_name, :string
    add_column :users, :family_name, :string
  end
end
