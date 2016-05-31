class CreatePatientLanguages < ActiveRecord::Migration
  def change
    create_table :patient_languages do |t|
      t.string :name, null: false
    end
  end
end
