class CreateAccessCatheterInsertionTechniques < ActiveRecord::Migration[5.0]
  def change
    create_table :access_catheter_insertion_techniques do |t|
      t.string :code, null: false
      t.string :description, null: false
      t.timestamps null: false
    end
  end
end
