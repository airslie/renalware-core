class CreateClinics < ActiveRecord::Migration[4.2]
  def change
    create_table :clinics do |t|
      t.string :name, null: false

      t.timestamps null: false
    end

    change_table :clinic_visits do |t|
      t.references :clinic, foreign_key: true, null: false
    end
  end
end
