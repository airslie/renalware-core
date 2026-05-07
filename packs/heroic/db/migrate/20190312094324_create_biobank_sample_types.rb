class CreateBiobankSampleTypes < ActiveRecord::Migration[5.2]
  # rubocop:disable Rails/NotNullColumn
  def change
    within_renalware_schema(suffix: :heroic) do
      create_table :biobank_sample_types do |t|
        t.string :name, null: false, unique: true
        t.string :abbreviation, null: false, unique: true, index: true
        t.timestamps null: false
      end

      add_reference :biobank_samples,
                    :sample_type,
                    references: :biobank_sample_types,
                    index: true,
                    null: false
      remove_column :biobank_samples, :sample_type, :string
      add_column :biobank_samples, :isbt, :string
      add_column :biobank_aliquots, :isbt, :string
    end
  end
  # rubocop:enable Rails/NotNullColumn
end
