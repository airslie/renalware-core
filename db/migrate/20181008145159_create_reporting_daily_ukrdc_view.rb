class CreateReportingDailyUKRDCView < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_view :reporting_daily_ukrdc
    end
  end
end
