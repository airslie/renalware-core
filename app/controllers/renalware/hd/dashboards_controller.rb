module Renalware
  module HD
    class DashboardsController < BaseController
      include Renalware::Concerns::PatientVisibility
      include Renalware::Concerns::PatientCasting

      def show
        authorize hd_patient
        render locals: {
          dashboard: DashboardPresenter.new(hd_patient, view_context, current_user),
          assessments: hd_patient.acuity_assessments.ordered.take(4)
        }
      end
    end
  end
end
