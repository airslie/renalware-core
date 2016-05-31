class AddTelephoneToDoctors < ActiveRecord::Migration
  def change
    add_column :doctors, :telephone, :string
  end
end
