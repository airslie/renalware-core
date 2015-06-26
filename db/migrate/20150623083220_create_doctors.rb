class CreateDoctors < ActiveRecord::Migration
  def change
    create_table :doctors do |t|
      t.string  :first_name
      t.string  :last_name
      t.string  :email
      t.string  :code
      t.integer :address_id
      t.string  :practitioner_type, null: false
      t.timestamps null: false
    end
    add_index :doctors, :code, unique: true
  end
end
