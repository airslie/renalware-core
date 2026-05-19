class UpdateOverdueReports < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema(suffix: :heroic) do
      update_view(:report_overdue_ecg, version: 2, revert_to_version: 1)
      update_view(:report_overdue_echo, version: 2, revert_to_version: 1)
      update_view(:report_overdue_mgfr, version: 2, revert_to_version: 1)
      update_view(:report_overdue_octa, version: 2, revert_to_version: 1)
    end
  end
end
