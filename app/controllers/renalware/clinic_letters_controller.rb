module Renalware
  class ClinicLettersController < BaseController
    load_and_authorize_resource

    before_filter :load_clinic_visit

    def new
      @letter = ClinicLetter.new(patient: @clinic_visit.patient, clinic_visit: @clinic_visit)
      @patient = @letter.patient
      render 'renalware/letters/new'
    end

    def edit
      @letter = ClinicLetter.find(params[:id])
      @patient = @letter.patient
      render 'renalware/letters/edit'
    end

    private

    def load_clinic_visit
      @clinic_visit = ClinicVisit.find(params[:clinic_visit_id])
    end

    def load_patient
      return super if params[:patient_id].present?
      @patient = load_clinic_visit.patient
    end
  end
end