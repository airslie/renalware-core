class CreateHDCannulationTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :hd_cannulation_types do |t|
      t.string :name, null: false
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
