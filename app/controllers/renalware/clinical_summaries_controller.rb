module Renalware
  class ClinicalSummariesController < BaseController
    skip_authorize_resource only: :show

    def show
      @patient = Patient.find(params[:patient_id])
    end
  end
end
