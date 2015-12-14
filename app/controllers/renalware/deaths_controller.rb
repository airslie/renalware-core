module Renalware
  class DeathsController < BaseController
    before_action :load_patient, only: [:edit, :update]

    def index
      @patients = Patient.dead
      authorize @patients
    end

    def update
      if @patient.update(death_params)
        redirect_to patient_path(@patient),
          notice: t(".success", model_name: "patient")
      else
        render :edit
      end
    end

    private

    def death_params
      params.require(:patient).permit(
        :died_on, :first_edta_code_id, :second_edta_code_id, :death_notes
      )
    end
  end
end
