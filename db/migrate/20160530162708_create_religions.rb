class CreateReligions < ActiveRecord::Migration
  def change
    create_table :religions do |t|
      t.string :name, null: false
    end
  end
end
