class PatientsController < ApplicationController

  def clinical_summary
    
  end

  def create
    @patient = Patient.create!(allowed_params)
    redirect_to patient_path(@patient)
  end

  def index
    @patients = Patient.all
  end

  def demographics
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
  def allowed_params
    params.require(:patient).permit(:nhs_number, :surname, :forename, :dob,
      :current_address_attributes => [:street_1, :street_2, :county, :city, :postcode],
      :address_at_diagnosis_attributes => [:street_1, :street_2, :county, :city, :postcode])
  end

end
