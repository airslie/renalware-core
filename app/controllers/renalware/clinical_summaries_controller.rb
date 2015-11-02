module Renalware
  class ClinicalSummariesController < BaseController

    skip_after_action :verify_authorized

    def show
      @patient = Patient.find(params[:patient_id])
      @events = Events::Event.for_patient(@patient)
    end
  end
end
