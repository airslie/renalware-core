class UpdateReportActivityV2 < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema(suffix: :heroic) do
      drop_view :report_participants_with_missing_data, revert_to_version: 1
      update_view :heroic_participants, version: 2, revert_to_version: 1
      update_view :report_activity, version: 2, revert_to_version: 1
      create_view :report_participants_with_missing_data
    end
  end
end
