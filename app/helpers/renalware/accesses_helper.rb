module Renalware
  module AccessesHelper
    def access_summary_breadrumb(patient)
      breadcrumb_for("Access Summary", patient_accesses_dashboard_path(patient))
    end

    def access_assesment_breadcrumb(patient, assessment)
      breadcrumb_for("Access Assessment", patient_accesses_assessment_path(patient, assessment))
    end

    def access_procedure_breadcrumb(patient, procedure)
      breadcrumb_for("Access Procedure", patient_accesses_procedure_path(patient, procedure))
    end

    def access_profile_breadcrumb(patient, profile)
      breadcrumb_for("Access Profile", patient_accesses_profile_path(patient, profile))
    end
  end
end
