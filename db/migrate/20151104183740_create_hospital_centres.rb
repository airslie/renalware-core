class CreateHospitalCentres < ActiveRecord::Migration[4.2]
  def change
    create_table :hospital_centres do |t|
      t.string :code, index: true, null: false
      t.string :name, null: false
      t.string :location
      t.boolean :active
      t.boolean :is_transplant_site, default: false, null: false

      t.timestamps null: false
    end
  end
end
