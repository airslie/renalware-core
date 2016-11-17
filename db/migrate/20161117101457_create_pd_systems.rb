class CreatePDSystems < ActiveRecord::Migration
  def change
    create_table :pd_systems do |t|
      t.string :pd_type, null: false, index: true
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
