class ModalitiesController < RenalwareController

  before_filter :load_patient

  def new
    @modality = Modality.new(patient: @patient)
  end

  def index
    @modalities = @patient.modalities.with_deleted.order('termination_date DESC')
  end

  def create
    @patient.set_modality(modality_params)

    if @patient.modality_code.death?
      redirect_to death_update_patient_path(@patient), :notice => "Please make sure to update patient date of death and cause of death!"
    else
      redirect_to patient_modalities_path(@patient)
    end
  end

  private

  def modality_params
    params.require(:modality).permit(
      :patient_id, :modality_code_id, :modality_change_type,
      :modality_reason_id, :notes, :start_date)
  end
end
