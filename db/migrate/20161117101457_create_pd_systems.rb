class CreatePDSystems < ActiveRecord::Migration[4.2]
  def change
    create_table :pd_systems do |t|
      t.string :pd_type, null: false, index: true
      t.string :name, null: false
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
