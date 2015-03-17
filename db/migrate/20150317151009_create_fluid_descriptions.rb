class CreateFluidDescriptions < ActiveRecord::Migration
  def change
    create_table :fluid_descriptions do |t|

      t.timestamps null: false
    end
  end
end
