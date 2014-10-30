class PatientEventsController < ApplicationController

  def new
    @patient_event = PatientEvent.new
  end

  def create
    @patient_event = PatientEvent.new(allowed_params)
    if @patient_event.save
      redirect_to patient_events_path, :notice => "You have successfully added an encounter/event."
    else
      render :new
    end
  end

  def index
    @patient_events = PatientEvent.all
  end

  def allowed_params
    params.require(:patient_event).permit(:date_time, :user_id, :patient_event_type,
      :description, :notes)
  end
end
