class CreateAdministrations < ActiveRecord::Migration
  def change
    create_table :administrations do |t|
      t.string :name 
    end
  end
end
