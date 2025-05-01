class UpdateUKRDCDailySummariesView < ActiveRecord::Migration[8.0]
  def change
    within_renalware_schema do
      update_view :ukrdc_daily_summaries,
                  version: 2,
                  revert_to_version: 1
    end
  end
end
