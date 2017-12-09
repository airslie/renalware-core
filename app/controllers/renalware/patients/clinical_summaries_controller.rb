require_dependency "renalware/patients"

module Renalware
  module Patients
    class ClinicalSummariesController < BaseController
      skip_after_action :verify_authorized
      before_action :load_patient

      def show
        clinical_summary = Renal::ClinicalSummaryPresenter.new(patient)
        render :show, locals: { clinical_summary: clinical_summary, patient: patient }
      end
    end
  end
end
