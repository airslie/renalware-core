class CreateDailyReports < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      create_view :reporting_daily_pathology
      create_view :reporting_daily_letters
    end
  end
end
