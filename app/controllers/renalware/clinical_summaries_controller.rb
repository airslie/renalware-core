module Renalware
  class ClinicalSummariesController < BaseController

    def show
      @patient = Patient.find(params[:patient_id])
      authorize @patient
    end
  end
end
