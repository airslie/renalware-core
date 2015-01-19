class CreatePrdCodes < ActiveRecord::Migration
  def change
    create_table :prd_codes do |t|
      t.string :code
      t.string :term
      t.timestamps null: true
    end
  end
end
