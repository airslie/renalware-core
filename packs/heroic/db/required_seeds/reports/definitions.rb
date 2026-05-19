# frozen_string_literal: true

module Renalware::Heroic
  Rails.benchmark "Adding Heroic Report Definitions" do
    Reports::Definition.find_or_create_by!(
      report_view_name: "report_activity"
    ) do |definition|
      definition.name = "1. Activity"
      definition.description = "Lists all patients entered into HEROIC"
      definition.position = 1
    end

    Renalware::Heroic::Reports::Definition.find_or_create_by!(
      report_view_name: "report_participants_with_missing_data"
    ) do |definition|
      definition.name = "2. Baseline data report"
      definition.description = "List of patients entered in HEROIC (excluding patients that withdraw before visit 1) who have missing / NULL data"
      definition.position = 2
    end

    Renalware::Heroic::Reports::Definition.find_or_create_by!(
      report_view_name: "report_mri_appointments"
    ) do |definition|
      definition.name = "3. MRI appointments"
      definition.description = "List Active Patients to manage MRI appointments"
      definition.position = 3
    end

    Renalware::Heroic::Reports::Definition.find_or_create_by!(
      report_view_name: "report_mri_activity"
    ) do |definition|
      definition.name = "6. MRI activity log"
      definition.position = 6
    end

    Renalware::Heroic::Reports::Definition.find_or_create_by!(
      report_view_name: "report_biobank_phlebotomy_appointments"
    ) do |definition|
      definition.name = "7. Biobank phlebotomy appointments"
      definition.description = "List Active Patients to manage phlebotomy for biobank appointment"
      definition.position = 7
    end

    Renalware::Heroic::Reports::Definition.find_or_create_by!(
      report_view_name: "report_biobank_reconciliation"
    ) do |definition|
      definition.name = "8. BioBank reconciliation"
      definition.description = ""
      definition.position = 8
    end

    Renalware::Heroic::Reports::Definition.find_or_create_by!(
      report_view_name: "report_biobank_activity"
    ) do |definition|
      definition.name = "9. BioBank activity log"
      definition.description = ""
      definition.position = 9
    end

    Renalware::Heroic::Reports::Definition.find_or_create_by!(
      report_view_name: "report_overdue_mgfr"
    ) do |definition|
      definition.name = "11. Tracking overdue event mGFR"
      definition.description = ""
      definition.position = 11
    end

    Renalware::Heroic::Reports::Definition.find_or_create_by!(
      report_view_name: "report_overdue_echo"
    ) do |definition|
      definition.name = "12. Tracking overdue event echo"
      definition.description = ""
      definition.position = 12
    end

    Renalware::Heroic::Reports::Definition.find_or_create_by!(
      report_view_name: "report_overdue_octa"
    ) do |definition|
      definition.name = "13. Tracking overdue event OCT-A (Retinal screen)"
      definition.description = ""
      definition.position = 13
    end

    Renalware::Heroic::Reports::Definition.find_or_create_by!(
      report_view_name: "report_overdue_ecg"
    ) do |definition|
      definition.name = "14. Tracking overdue event ECG"
      definition.description = ""
      definition.position = 14
    end

    Renalware::Heroic::Reports::Definition.find_or_create_by!(
      report_view_name: "report_incomplete_clinic_visits"
    ) do |definition|
      definition.name = "15. Data completeness for each HEROIC visit"
      definition.description = ""
      definition.position = 15
    end

    Renalware::Heroic::Reports::Definition.find_or_create_by!(
      report_view_name: "report_participants_with_missing_clinic_visits"
    ) do |definition|
      definition.name = "16. Missing Heroic clinic visit"
      definition.description = ""
      definition.position = 16
    end
  end
end
