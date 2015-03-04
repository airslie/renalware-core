class CreateAntibiotics < ActiveRecord::Migration
  def change
    create_table :antibiotics do |t|
      t.string :name
      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
