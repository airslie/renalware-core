class UpdateReportParticipantsWithMissingData < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema(suffix: :heroic) do
      update_view(
        :report_participants_with_missing_data,
        version: 2,
        revert_to_version: 1
      )
    end
  end
end
