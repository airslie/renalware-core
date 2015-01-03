class CreateEdtaCodes < ActiveRecord::Migration
  def change
    create_table :edta_codes do |t|
      t.integer :code
      t.string :death_cause
      t.datetime :deleted_at 
      t.timestamps
    end
  end
end
