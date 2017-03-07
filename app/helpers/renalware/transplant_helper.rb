module Renalware
  module TransplantHelper
    def donor_summary_breadcrumb(patient)
      breadcrumb_for("Transplant Donor Summary",
                     patient_transplants_donor_dashboard_path(patient))
    end

    def donor_workup_breadrumb(patient)
      breadcrumb_for("Workup", patient_transplants_donor_workup_path(patient))
    end

    def donor_operation_breadcrumb(patient, operation, with_timestamp: false)
      title = "Operation"
      title += " #{l(operation.performed_on)}" if with_timestamp
      breadcrumb_for(title, patient_transplants_donor_operation_path(patient, operation))
    end

    def donor_donation_breadcrumb(patient, donation)
      breadcrumb_for("Donation", patient_transplants_donation_path(patient, donation))
    end
  end
end
