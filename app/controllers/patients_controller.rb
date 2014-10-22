class PatientsController < ApplicationController

  def create
    @patient = Patient.create!(allowed_params)
    redirect_to patient_path(@patient)
  end

  def index
    @patients = Patient.all
  end
  
  def show
    @patient = Patient.find(params[:id])
  end

  def edit
    @patient = Patient.find(params[:id])
  end

  def update
    @patient = Patient.find(params[:id])
    @patient.update(allowed_params)
    redirect_to patient_path(@patient)
  end

  private
  def allowed_params #whitelist
    params.require(:patient).permit(:nhs_number, :surname, :forename, :dob) #for each attribute in the model /white_listed
  end

end
