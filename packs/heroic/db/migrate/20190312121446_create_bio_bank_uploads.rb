class CreateBioBankUploads < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema(suffix: :heroic) do
      create_table :biobank_uploads do |t|
        t.timestamps null: false
        t.references :updated_by, foreign_key: { to_table: :users }, index: true, null: false
        t.references :created_by, foreign_key: { to_table: :users }, index: true, null: false
      end
    end
  end
end
