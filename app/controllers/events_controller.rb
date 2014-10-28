class EventsController < ApplicationController

  def new
    # @patient = Patient.find(params[:id])
    @event = Event.new
  end

  def create
     @event = Event.new(allowed_params)
    if @event.save
      redirect_to events_path, :notice => "You have successfully added an encounter/event."
    else
      render :new
    end
  end

  def index
    @events = Event.all
  end

  def allowed_params
    params.require(:event).permit(:enc_date, :staff_name, :enc_type,
      :enc_descript, :enc_notes)
  end
end
