class CreateDrugsPatients < ActiveRecord::Migration
  def change
    create_table :drugs_patients do |t|
      t.integer :drug_id
      t.integer :patient_id
      t.timestamps
    end
  end
end
