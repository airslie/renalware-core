class CreateModalityChangeTypes < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      within_renalware_schema do
        create_table :modality_change_types do |t|
          t.string :code, null: false
          t.string :name, null: false
          t.boolean :default, null: false, default: false
          t.references :created_by, index: true, null: false, foreign_key: { to_table: :users }
          t.references :updated_by, index: true, null: false, foreign_key: { to_table: :users }
          t.datetime :deleted_at, index: true
          t.timestamps null: :false
        end

        add_reference(
          :modality_modalities,
          :change_type,
          foreign_key: { to_table: "modality_change_types" },
          index: true
        )

        add_index(
          :modality_change_types,
          :default,
          where: "\"default\" = true",
          unique: true
        )

        # Rename the old column - we will map its data to the new modality_change_type_id column
        # in a data migration in the host app.
        rename_column :modality_modalities, :modal_change_type, :modal_change_type_deprecated
      end
    end
  end
end
