class CreateConsults < ActiveRecord::Migration[5.1]
  def change
    create_table :admission_consults do |t|
      t.references :hospital_unit, foreign_key: true, index: true, null: false
      t.references :patient, foreign_key: true, index: true, null: false
      t.references :updated_by, foreign_key: { to_table: :users }, index: true, null: false
      t.references :created_by, foreign_key: { to_table: :users }, index: true, null: false
      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
