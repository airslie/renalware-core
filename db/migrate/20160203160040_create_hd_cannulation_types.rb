class CreateHDCannulationTypes < ActiveRecord::Migration
  def change
    create_table :hd_cannulation_types do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
