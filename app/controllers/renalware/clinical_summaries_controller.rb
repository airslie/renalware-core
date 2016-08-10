require_dependency "renalware"

module Renalware
  class ClinicalSummariesController < BaseController

    skip_after_action :verify_authorized

    before_action :load_patient

    def show
      clinical_summary = Renal::ClinicalSummaryPresenter.new(@patient)
      @events = Events::Event.for_patient(@patient)

      render :show, locals: { clinical_summary: clinical_summary }
    end
  end
end
