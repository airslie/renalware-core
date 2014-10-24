class PatientsController < ApplicationController

  def clinical_summary
    
  end

  def new
    @patient = Patient.new
  end

  def create
    @patient = Patient.new(allowed_params)
    if @patient.save
      redirect_to patients_path(@patient), :notice => "You have successfully added a new patient." 
    else
      render :new  
    end
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
    redirect_to patients_path(@patient)
  end

  private
  def allowed_params
    params.require(:patient).permit(:nhs_number, :surname, :forename, :sex, :dob,
      :current_address_attributes => [:street_1, :street_2, :county, :city, :postcode],
      :address_at_diagnosis_attributes => [:street_1, :street_2, :county, :city, :postcode])
  end

end
