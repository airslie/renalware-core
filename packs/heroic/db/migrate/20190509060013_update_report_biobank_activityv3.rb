class UpdateReportBiobankActivityv3 < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema(suffix: :heroic) do
      update_view(
        :report_biobank_activity,
        version: 3,
        revert_to_version: 2
      )
    end
  end
end
