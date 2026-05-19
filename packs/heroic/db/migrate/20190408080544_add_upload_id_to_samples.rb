class AddUploadIdToSamples < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema(suffix: :heroic) do
      add_reference :biobank_samples,
                    :upload,
                    references: :biobank_uploads,
                    index: true,
                    null: true
      add_reference :biobank_aliquots,
                    :upload,
                    references: :biobank_uploads,
                    index: true,
                    null: true
      add_reference :biobank_usages,
                    :upload,
                    references: :biobank_uploads,
                    index: true,
                    null: true

      remove_column :biobank_samples, :usable_count, :integer
    end
  end
end
