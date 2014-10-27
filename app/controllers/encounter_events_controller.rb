class EncounterEventsController < ApplicationController

  def new
    # @patient = Patient.find(params[:id])
    @encounter_event = EncounterEvent.new
  end

  def create
     @encounter_event = EncounterEvent.new(allowed_params)
    if @encounter_event.save
      redirect_to encounter_events_path, :notice => "You have successfully added an encounter/event."
    else
      render :new
    end
  end

  def index
    @encounter_events = EncounterEvent.all
  end 

  def allowed_params
    params.require(:encounter_event).permit(:enc_date, :staff_name, :enc_type,
      :enc_descript, :enc_notes)
  end
end
