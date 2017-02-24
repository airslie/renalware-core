module Renalware
  module TransplantHelper
    def donor_summary_breadrumb(patient)
      breadcrumb_for("Transplant Donor Summary",
                     patient_transplants_donor_dashboard_path(patient))
    end

    def donor_workup_breadrumb(patient)
      breadcrumb_for("Workup", patient_transplants_donor_workup_path(patient))
    end
  end
end
