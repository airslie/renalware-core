module Renalware
  class ESRFController < BaseController
    skip_authorize_resource only: [:edit, :update]

    before_action :find_patient, :find_prd_descriptions

    def edit
      @esrf = ESRF.find_or_initialize_by(patient: @patient)
    end

    def update
      @esrf = ESRF.find_or_initialize_by(patient: @patient)

      if @esrf.update_attributes(esrf_params)
        redirect_to patient_clinical_summary_path(@patient), notice: t(".success")
      else
        render :edit
      end
    end

    private

    def find_patient
      @patient = Patient.find(params[:patient_id])
    end

    def find_prd_descriptions
      @prd_descriptions = PRDDescription.ordered
    end

    def esrf_params
      params.require(:esrf).permit(:diagnosed_on, :prd_description_id)
    end
  end
end
