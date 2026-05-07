class AddStatusToBiobankUploads < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema(suffix: :heroic) do
      add_column :biobank_uploads, :status, :integer, null: false, default: 0
      add_column :biobank_uploads, :file_type, :integer, default: 0
      add_column :biobank_uploads, :staged_changes, :jsonb, default: 0
    end
  end
end
