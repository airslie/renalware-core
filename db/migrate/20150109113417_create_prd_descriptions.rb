class CreatePRDDescriptions < ActiveRecord::Migration
  def change
    create_table :prd_descriptions do |t|
      t.string :code
      t.string :term
      t.timestamps null: false
    end
  end
end
