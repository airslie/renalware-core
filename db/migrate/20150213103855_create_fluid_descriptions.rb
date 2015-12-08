class CreateFluidDescriptions < ActiveRecord::Migration
  def change
    create_table :fluid_descriptions do |t|
      t.string :description
      t.datetime :deleted_at 
      t.timestamps null: false
    end
  end
end
