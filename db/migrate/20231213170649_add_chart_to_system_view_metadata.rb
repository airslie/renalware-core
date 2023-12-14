class AddChartToSystemViewMetadata < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      within_renalware_schema do
        add_column :system_view_metadata, :chart, :jsonb, default: {}, null: false
      end
    end
  end
end
