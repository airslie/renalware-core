class PatientModalitiesController < ApplicationController

  before_filter :find_patient

  def new
    @modality = PatientModality.new(patient: @patient)
  end

  def index
    # TODO: Ordering is incorrect here as an arbitrary date
    # of termination can be set.
    @modalities = @patient.patient_modalities.with_deleted.order('deleted_at DESC')
  end

  def create
    @patient.set_modality(modality_params)

    redirect_to patient_patient_modalities_path(@patient)
  end

  private

  def modality_params
    params.require(:modality).permit(
      :patient_id, :user_id, :modality_code_id,
      :modality_change_type, :modality_reason_id, :date)
  end

  def find_patient
    @patient = Patient.find(params[:patient_id])
  end
end
