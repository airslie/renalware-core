class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street_1
      t.string :street_2
      t.string :county
      t.string :city
      t.string :postcode

      t.timestamps
    end
  end
end
