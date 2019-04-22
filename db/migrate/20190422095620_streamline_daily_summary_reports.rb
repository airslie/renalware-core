class StreamlineDailySummaryReports < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      update_view(
        :reporting_daily_pathology,
        version: 3,
        revert_to_version: 2
      )
    end
  end
end
