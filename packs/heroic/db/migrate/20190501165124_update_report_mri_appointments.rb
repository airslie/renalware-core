class UpdateReportMriAppointments < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema(suffix: :heroic) do
      replace_view(
        :report_mri_appointments,
        version: 3,
        revert_to_version: 2
      )
    end
  end
end
