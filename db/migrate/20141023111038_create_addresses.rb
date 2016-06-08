class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :addressable_type, null: false
      t.integer :addressable_id, null: false
      t.string :street_1
      t.string :street_2
      t.string :county
      t.string :city
      t.string :postcode

      t.timestamps null: false
    end

    add_index :addresses, [:addressable_type, :addressable_id]
  end
end
