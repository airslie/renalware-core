class CreateReports < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema(suffix: :heroic) do
      create_view :heroic_clinic_visits
      create_view :report_biobank_reconciliation
      create_view :report_biobank_activity
      create_view :report_overdue_mgfr
      create_view :report_overdue_echo
      create_view :report_overdue_octa
      create_view :report_overdue_ecg
      create_view :report_incomplete_clinic_visits
      create_view :report_participants_with_missing_clinic_visits
    end
  end
end
