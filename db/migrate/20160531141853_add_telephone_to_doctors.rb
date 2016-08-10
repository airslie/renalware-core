class AddTelephoneToDoctors < ActiveRecord::Migration
  def change
    add_column :doctor_doctors, :telephone, :string
  end
end
