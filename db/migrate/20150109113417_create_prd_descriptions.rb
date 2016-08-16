class CreatePRDDescriptions < ActiveRecord::Migration
  def change
    create_table :renal_prd_descriptions do |t|
      t.string :code
      t.string :term
      t.timestamps null: false
    end
  end
end
