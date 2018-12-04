class CreateHospitalWards < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      create_table :hospital_wards do |t|
        t.string :name, null: false
        t.references :hospital_unit, index: true, foreign_key: true, null: false
        t.datetime :deleted_at
        t.timestamps null: false
      end

      # This create a postgres partial index
      # Name must be unique in for any unit, but only amongst un-deleted wards.
      add_index :hospital_wards,
                [:name, :hospital_unit_id],
                unique: true,
                where: "deleted_at IS NOT NULL"
    end
  end
end
