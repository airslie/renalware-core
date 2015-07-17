class ClinicsController < RenalwareController
  before_filter :load_patient
  before_filter :load_clinic, only: [:edit, :update, :destroy]

  def index
    @clinics = @patient.clinics
  end

  def new
    @clinic = Clinic.new(patient: @patient)
  end

  def create
    @clinic = Clinic.new(clinic_params)

    if @clinic.save
      redirect_to patient_clinics_path(@patient)
    else
      flash[:error] = 'Failed to save clinic'
      render :new
    end
  end

  def update
    if @clinic.update_attributes(clinic_params)
      redirect_to patient_clinics_path(@patient)
    else
      flash[:error] = 'Failed to update clinic'
      render :new
    end
  end

  def destroy
    if @clinic.destroy
      redirect_to patient_clinics_path(@patient)
    else
      flash[:error] = 'Failed to delete clinic'
      render :index
    end
  end

  private

  def clinic_params
    params.require(:clinic).permit(
      :patient_id, :date, :height, :weight,
      :bp, :urine_blood, :urine_protein, :notes)
  end

  def load_clinic
    @clinic = Clinic.find(params[:id])
  end
end
