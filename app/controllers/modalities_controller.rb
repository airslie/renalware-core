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
    if @patient.modality_code.name == 'Death'
      redirect_to edit_patient_path(@patient), :notice => "Please make sure to update patient date of death and cause of death!"
    else
      redirect_to clinical_summary_patient_path(@patient)
    end    
  end

  private

  def modality_params
    params.require(:modality).permit(
      :patient_id, :user_id, :modality_code_id, :modality_change_type,
      :modality_reason_id, :start_date)
  end

  def find_patient
    @patient = Patient.find(params[:patient_id])
  end
end
