class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.integer :patient_id, null: false
      t.string :description, null: false
      t.date :date
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
