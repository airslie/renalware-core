class CreateMedicationRoutes < ActiveRecord::Migration[4.2]
  def change
    create_table :medication_routes do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
