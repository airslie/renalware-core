class CreateClinicTypes < ActiveRecord::Migration
  def change
    create_table :clinic_types do |t|
      t.string :name, null: false

      t.timestamps null: false
    end

    change_table :clinic_visits do |t|
      t.references :clinic_type, foreign_key: true, null: false
    end
  end
end
