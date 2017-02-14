class AddTelephoneToDoctors < ActiveRecord::Migration[4.2]
  def change
    add_column :doctor_doctors, :telephone, :string
  end
end
