class CreateFluidDescriptions < ActiveRecord::Migration[4.2]
  def change
    create_table :pd_fluid_descriptions do |t|
      t.string :description
      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
