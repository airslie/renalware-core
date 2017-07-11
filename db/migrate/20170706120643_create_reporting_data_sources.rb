class CreateReportingDataSources < ActiveRecord::Migration[5.0]
  def change
    create_view :reporting_data_sources
  end
end
