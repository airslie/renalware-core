module Renalware
  module PDHelper
    def pd_summary_breadcrumb(patient)
      breadcrumb_for("PD Summary", patient_pd_dashboard_path(patient))
    end
  end
end
