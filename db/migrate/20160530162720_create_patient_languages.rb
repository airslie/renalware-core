class CreatePatientLanguages < ActiveRecord::Migration[4.2]
  def change
    create_table :patient_languages do |t|
      t.string :name, null: false
    end
  end
end
