class CreateEsrfInfos < ActiveRecord::Migration
  def change
    create_table :esrf_infos do |t|
      t.integer :patient_id
      t.integer :user_id
      t.date :date
      t.integer :prd_code_id  
      t.timestamps null: true
    end
  end
end
