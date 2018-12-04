class UpdateReportingDailyPathologyViewToV2 < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      update_view(
        :reporting_daily_pathology,
        version: 2,
        revert_to_version: 1
      )
    end
  end
end
