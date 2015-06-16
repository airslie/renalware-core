class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.integer :patient_id
      t.string :description
      t.date :date
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
