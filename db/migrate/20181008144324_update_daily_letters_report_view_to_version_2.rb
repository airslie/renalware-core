class UpdateDailyLettersReportViewToVersion2 < ActiveRecord::Migration[5.2]
  def change
    update_view(
      :reporting_daily_letters,
      version: 2,
      revert_to_version: 1
    )
  end
end
