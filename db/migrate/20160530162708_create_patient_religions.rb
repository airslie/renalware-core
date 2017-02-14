class CreatePatientReligions < ActiveRecord::Migration[4.2]
  def change
    create_table :patient_religions do |t|
      t.string :name, null: false
    end
  end
end
