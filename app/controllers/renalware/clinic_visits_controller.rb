module Renalware
  class ClinicVisitsController < BaseController

    before_filter :load_patient
    before_filter :load_clinic_visit, only: [:edit, :update, :destroy]

    def index
      @clinic_visits = @patient.clinic_visits
    end

    def new
      @clinic_visit = @patient.clinic_visits.new
    end

    def create
      @clinic_visit = @patient.clinic_visits.new(clinic_visit_params)
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
      @clinic_visit.destroy
      redirect_to patient_clinic_visits_path(@patient),
        notice: "Patient's clinic visit successfully deleted"
    end

    private

    def clinic_visit_params
      params.require(:clinic_visit).permit(
        :date, :clinic_type_id, :height, :weight,
        :bp, :urine_blood, :urine_protein, :notes
      ).merge(by: current_user)
    end

    def load_clinic_visit
      @clinic_visit = ClinicVisit.find(params[:id])
    end
  end
end
