class ClinicLettersController < LettersController
  before_filter :load_clinic

  def new
    @letter = ClinicLetter.new(patient: @clinic.patient, clinic: @clinic)
  end

  def edit
    @letter = ClinicLetter.find(params[:id])
  end

  private

  def load_clinic
    @clinic = Clinic.find(params[:clinic_id])
  end

  def load_patient
    return super if params[:patient_id].present?
    @patient = load_clinic.patient
  end
end
