class CreateClinicalAllergies < ActiveRecord::Migration
  def change
    create_table :clinical_allergies do |t|
      t.references :patient, index: true, null: false
      t.text :description, null: false
      t.datetime :recorded_at, null: false
      t.datetime :deleted_at
      t.references :created_by, index: true, null: false
      t.references :updated_by, index: true, null: false
    end

    add_foreign_key :clinical_allergies, :patients, column: :patient_id
    add_foreign_key :clinical_allergies, :users, column: :created_by_id
    add_foreign_key :clinical_allergies, :users, column: :updated_by_id

    # See Clinical::Patient#allergy_status for possible values
    add_column :patients, :allergy_status, :string, null: false, default: "unrecorded"
  end
end
