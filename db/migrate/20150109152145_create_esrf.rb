class CreateESRF < ActiveRecord::Migration
  def change
    create_table :esrf do |t|
      t.integer :patient_id
      t.date :diagnosed_on
      t.integer :prd_description_id
      t.timestamps null: true
    end
  end
end
