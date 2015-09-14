module Renalware
  class ClinicLettersController < BaseController
    load_and_authorize_resource

    before_filter :load_clinic_visit
    before_filter :load_letter, except: :new

    def new
      @letter = ClinicLetter.new(patient: @clinic_visit.patient, clinic_visit: @clinic_visit)
      @patient = @letter.patient
      render 'renalware/letters/new'
    end

    private

    def load_letter
      @letter = ClinicLetter.find(params[:id])
    end

    def load_clinic_visit
      @clinic_visit = ClinicVisit.find(params[:clinic_visit_id])
    end
  end
end