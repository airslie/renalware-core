module Renalware
  class MedicationsController < BaseController
    before_action :load_patient, only: [:index, :update]

    def index
      render
    end

    def update
      authorize @patient
      if @patient.update(medication_params)
        redirect_to patient_medications_path(@patient),
          notice: t(".success", model_name: "medication")
      else
        flash[:error] = t(".failed", model_name: "medication")
        render :index
      end
    end

    private

    def medication_params
      params.require(:patient).permit(
        medications_attributes: [
          :id, :drug_id, :dose, :medication_route_id,
          :frequency, :notes, :start_date, :end_date, :provider, :_destroy
        ]
      )
    end
  end
end
