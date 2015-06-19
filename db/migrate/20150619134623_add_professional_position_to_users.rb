class AddProfessionalPositionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :professional_position, :string
  end
end
