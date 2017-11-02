class CreateConsults < ActiveRecord::Migration[5.1]
  def change
    create_table :admission_consults do |t|
      t.references :hospital_unit, foreign_key: true, index: true
      t.references :hospital_ward, foreign_key: true, index: true
      t.references :patient, foreign_key: true, index: true, null: false
      t.date :consult_on
      t.date :decided_on
      t.date :transfer_on
      t.string :transfer_priority
      t.string :aki_risk
      t.string :seen_by
      t.references :updated_by, foreign_key: { to_table: :users }, index: true, null: false
      t.references :created_by, foreign_key: { to_table: :users }, index: true, null: false
      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
