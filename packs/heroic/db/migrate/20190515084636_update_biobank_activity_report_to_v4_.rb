class UpdateBiobankActivityReportToV4 < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema(suffix: :heroic) do
      update_view(
        :report_biobank_activity,
        version: 4,
        revert_to_version: 3
      )
    end
  end
end
