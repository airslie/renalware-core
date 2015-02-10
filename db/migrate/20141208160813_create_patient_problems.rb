class CreatePatientProblems < ActiveRecord::Migration
  def change
    create_table :patient_problems do |t|
      t.integer :patient_id
      t.string :description
      t.date :date
      t.integer :user_id
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
