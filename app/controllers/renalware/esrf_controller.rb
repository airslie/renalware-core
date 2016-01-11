module Renalware
  class ESRFController < BaseController

    before_action :load_patient

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

    def esrf_params
      params.require(:esrf).permit(:diagnosed_on, :prd_description_id)
    end
  end
end
