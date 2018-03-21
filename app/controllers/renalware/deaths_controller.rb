# frozen_string_literal: true

module Renalware
  class DeathsController < BaseController
    include PresenterHelper
    include Renalware::Concerns::Pageable

    def index
      patients = Patient.dead.page(page).per(per_page)
      authorize patients
      render locals: { patients: present(patients, PatientPresenter) }
    end

    def edit
      authorize patient
      render_edit
    end

    def update
      authorize patient
      if patient.update(death_params)
        redirect_to patient_clinical_profile_path(patient),
          notice: t(".success", model_name: "patient")
      else
        flash.now[:error] = t(".failed", model_name: "patient")
        render_edit
      end
    end

    private

    def render_edit
      render :edit, locals: { patient: patient }
    end

    def death_params
      params
        .require(:patient)
        .permit(:died_on, :first_cause_id, :second_cause_id, :death_notes)
        .merge(by: current_user)
    end
  end
end
