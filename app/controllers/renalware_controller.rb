class RenalwareController < ApplicationController
  # Cancancan authorization filter
  load_and_authorize_resource

  def load_patient
    @patient = Patient.find(params[:patient_id])
  end
end
