class CreateDoctors < ActiveRecord::Migration
  def change
    create_table :doctor_doctors do |t|
      t.string  :given_name
      t.string  :family_name
      t.string  :email
      t.string  :code
      t.string  :practitioner_type, null: false
      t.timestamps null: false
    end

    add_index :doctor_doctors, :code, unique: true
  end
end
