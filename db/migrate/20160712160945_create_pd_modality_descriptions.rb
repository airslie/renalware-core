class CreatePDModalityDescriptions < ActiveRecord::Migration
  def change
    create_table :pd_modality_descriptions do |t|
      t.references :description, null: false
      t.timestamps null: false
    end

    add_foreign_key :pd_modality_descriptions,
      :modality_descriptions, column: :description_id
  end
end
