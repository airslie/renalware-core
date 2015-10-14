module Renalware
  class EventsController < BaseController

    before_action :load_patient, :only => [:new, :create, :index]

    def new
      @event = Event.new
      authorize @event
      @event_type = EventType.new
    end

    def create
      @event = @patient.events.new(event_params)
      authorize @event

      if @event.save
        redirect_to patient_events_path(@patient), :notice => "You have successfully added an encounter/event."
      else
        render :new
      end
    end

    def index
      @events = @patient.events
      authorize @events
    end

    private
    def event_params
      params.require(:event).permit(:event_type_id, :date_time, :description, :notes)
    end
  end
end
