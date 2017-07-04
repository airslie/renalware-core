class CreateDeathCauses < ActiveRecord::Migration[4.2]
  def change
    create_table :death_causes do |t|
      t.integer :code
      t.string :description
      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
