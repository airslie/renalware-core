class CreateESRF < ActiveRecord::Migration
  def change
    create_table :esrf do |t|
      t.references :patient,            null: false, foreign_key: true
      t.date :diagnosed_on,          null: false
      t.references :prd_description, foreign_key: true
      t.timestamps null: true
    end
  end
end
