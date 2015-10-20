module Renalware
  class ClinicalSummariesController < BaseController

    skip_after_action :verify_authorized

    def show
      @patient = Patient.find(params[:patient_id])
      authorize @patient
    end
  end
end
