class PatientsController < ApplicationController
  before_action :load_patient, :only => [:clinical_summary, :medications, :demographics, :edit, :update] 

  def clinical_summary
    @patient_events = PatientEvent.all
    @patient_medications = PatientMedication.all
  end

  def medications
    @patient.patient_medications.build(:medication_type => "Drug")
  end

  def new
    @patient = Patient.new
  end

  def create
    @patient = Patient.new(allowed_params)
    if @patient.save
      redirect_to demographics_patient_path(@patient), :notice => "You have successfully added a new patient."
    else
      render :new
    end
  end

  def index
    @patients = Patient.all
  end

  def update
    @patient.update(allowed_params)
    redirect_to clinical_summary_patient_path(@patient)
  end

  private
  def allowed_params
    params.require(:patient).permit(:nhs_number, :local_patient_id, :surname,
      :forename, :sex, :ethnicity_id, :dob, :paediatric_patient_indicator,
      :gp_practice_code, :pct_org_code, :hosp_centre_code, :primary_esrf_centre,
      :current_address_attributes => [:street_1, :street_2, :county, :city, :postcode],
      :address_at_diagnosis_attributes => [:street_1, :street_2, :county, :city, :postcode],
      :patient_medications_attributes => [:id, :medication_id, :medication_type,:dose, :route, 
      :frequency, :notes, :date, :provider])
  end

  def load_patient
    @patient = Patient.find(params[:id])
  end

end
