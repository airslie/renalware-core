module Renalware
  class ClinicVisitsController < BaseController

    before_filter :load_patient
    before_filter :load_clinic_visit, only: [:edit, :update, :destroy]

    def index
      @clinic_visits = @patient.clinic_visits
      authorize @clinic_visits
    end

    def new
      @clinic_visit = ClinicVisit.new(patient: @patient)
      authorize @clinic_visit
    end

    def create
      @clinic_visit = ClinicVisit.new(clinic_visit_params)
      authorize @clinic_visit
      if @clinic_visit.save
        redirect_to patient_clinic_visits_path(@patient)
      else
        flash[:error] = 'Failed to save clinic'
        render :new
      end
    end

    def update
      if @clinic_visit.update_attributes(clinic_visit_params)
        redirect_to patient_clinic_visits_path(@patient)
      else
        flash[:error] = 'Failed to update clinic'
        render :new
      end
    end

    def destroy
      if @clinic_visit.destroy
        redirect_to patient_clinic_visits_path(@patient)
      else
        flash[:error] = 'Failed to delete clinic'
        render :index
      end
    end

    private

    def clinic_visit_params
      params.require(:clinic_visit).permit(
        :patient_id, :date, :height, :weight,
        :bp, :urine_blood, :urine_protein, :notes)
    end

    def load_clinic_visit
      @clinic_visit = ClinicVisit.find(params[:id])
      authorize @clinic_visit
    end
  end
end