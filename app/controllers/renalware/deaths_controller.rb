module Renalware
  class DeathsController < BaseController
    include PresenterHelper
    include Renalware::Concerns::Pageable

    before_action :load_patient, only: [:edit, :update]

    def index
      patients = Patient.dead.page(page).per(per_page)
      authorize patients
      @patients = present(patients, PatientPresenter)
    end

    def update
      if @patient.update(death_params)
        redirect_to patient_clinical_profile_path(@patient),
          notice: t(".success", model_name: "patient")
      else
        flash[:error] = t(".failed", model_name: "patient")
        render :edit
      end
    end

    private

    def death_params
      params
        .require(:patient)
        .permit(:died_on, :first_edta_code_id, :second_edta_code_id, :death_notes)
        .merge(by: current_user)
    end
  end
end
