class ModalitiesController < ApplicationController

  before_filter :find_patient

  def new
    @modality = Modality.new(patient: @patient)
  end

  def index
    @modalities = @patient.modalities.with_deleted.order('termination_date DESC')
  end

  def create
    @patient.set_modality(modality_params)

    redirect_to patient_modalities_path(@patient)    
  end

  private

  def modality_params
    params.require(:modality).permit(
      :patient_id, :modality_code_id, :modality_change_type,
      :modality_reason_id, :notes, :start_date)
  end

  def find_patient
    @patient = Patient.find(params[:patient_id])
  end
end
