class ClinicLettersController < LettersController
  before_filter :load_clinic_visit

  def new
    @letter = ClinicLetter.new(patient: @clinic_visit.patient, clinic_visit: @clinic_visit)
  end

  def edit
    @letter = ClinicLetter.find(params[:id])
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
