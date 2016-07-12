class CreateHDModalityDescriptions < ActiveRecord::Migration
  def change
    create_table :hd_modality_descriptions do |t|
      t.references :description, null: false
      t.timestamps null: false
    end

    add_foreign_key :hd_modality_descriptions,
      :modality_descriptions, column: :description_id
  end
end
