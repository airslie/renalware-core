class CreateHospitalUnits < ActiveRecord::Migration[4.2]
  def change
    create_table :hospital_units do |t|
      t.references :hospital_centre, foreign_key: true, null: false
      t.string :name, null: false
      t.string :unit_code, null: false
      t.string :renal_registry_code, null: false
      t.string :unit_type, null: false
      t.boolean :is_hd_site, default: false, null: false

      t.timestamps null: false
    end
  end
end
