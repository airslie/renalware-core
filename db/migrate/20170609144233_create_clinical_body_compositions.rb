class CreateClinicalBodyCompositions < ActiveRecord::Migration[5.0]
  def change
    create_table :clinical_body_compositions do |t|
      t.belongs_to :patient, index: true, foreign_key: true
      t.belongs_to :modality_description, index: true, foreign_key: true

      t.date :assessed_on, null: false
      t.decimal :overhydration, null: false, precision: 3, scale: 1
      t.decimal :volume_of_distribution, null: false, precision: 4, scale: 1
      t.decimal :total_body_water, null: false, precision: 4, scale: 1
      t.decimal :extracellular_water, null: false, precision: 4, scale: 1
      t.decimal :intracellular_water, null: false, precision: 3, scale: 1
      t.decimal :lean_tissue_index, null: false, precision: 4, scale: 1
      t.decimal :fat_tissue_index, null: false, precision: 4, scale: 1
      t.decimal :lean_tissue_mass, null: false, precision: 4, scale: 1
      t.decimal :fat_tissue_mass, null: false, precision: 4, scale: 1
      t.decimal :adipose_tissue_mass, null: false, precision: 4, scale: 1
      t.decimal :body_cell_mass, null: false, precision: 4, scale: 1
      t.decimal :quality_of_reading, null: false, precision: 6, scale: 3

      t.belongs_to :created_by, index: true, null: false
      t.belongs_to :updated_by, index: true, null: false

      t.timestamps null: false
    end

    add_reference :clinical_body_compositions, :assessor, references: :users, index: true, null: false
    add_foreign_key :clinical_body_compositions, :users, column: :assessor_id
  end
end
