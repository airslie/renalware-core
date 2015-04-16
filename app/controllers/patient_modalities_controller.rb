class PatientModalitiesController < ApplicationController
  def new
    @modality = PatientModality.new(patient: patient)
  end

  def index
    @modalities = patient.patient_modalities
  end

  def create
    if patient.patient_modality.present?
      @modality = patient.patient_modality.supersede!(params[:patient_modality])
    else
      @modality = PatientModality.create!(params[:patient_modality])
    end
    redirect_to patient_modalities_path
  end

  private

  def patient
    @patient ||= Patient.find(params[:patient_id])
  end
end
