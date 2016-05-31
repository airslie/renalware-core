class CreatePatientReligions < ActiveRecord::Migration
  def change
    create_table :patient_religions do |t|
      t.string :name, null: false
    end
  end
end
