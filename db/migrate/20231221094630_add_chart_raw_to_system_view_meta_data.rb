class AddChartRawToSystemViewMetaData < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      add_column :system_view_metadata, :chart_raw, :jsonb, default: {}, null: false
    end
  end
end
