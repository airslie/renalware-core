class CreateUKRDCDailySummariesView < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_view :ukrdc_daily_summaries
    end
  end
end
