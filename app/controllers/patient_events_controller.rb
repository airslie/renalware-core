class PatientEventsController < ApplicationController
  before_action :load_patient, :only => [:new, :create, :index]

  def new
    @patient_event = PatientEvent.new
    @patient_event_type = PatientEventType.new
  end

  def create
    @patient_event = PatientEvent.new(allowed_params)
    @patient_event.patient_id = @patient.id
    if @patient_event.save
      redirect_to patient_patient_events_path(@patient), :notice => "You have successfully added an encounter/event."
    else
      render :new
    end
  end

  def index
    @patient_event = PatientEvent.new
    @patient_events = @patient.patient_events
  end

  private
  def allowed_params
    params.require(:patient_event).permit(:patient_event_type_id, :date_time, :description, :notes)
  end

  def load_patient
    @patient = Patient.find(params[:patient_id])
  end
end
