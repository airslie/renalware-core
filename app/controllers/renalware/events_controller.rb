module Renalware
  class EventsController < BaseController

    before_action :load_patient, :only => [:new, :create, :index]

    def new
      @event = Event.new
      @event_type = EventType.new
    end

    def create
      @event = @patient.events.new(event_params)
      if @event.save
        redirect_to patient_events_path(@patient),
          notice: "You have successfully added a patient event."
      else
        render :new
      end
    end

    def index
      @events = @patient.events
    end

    private
    def event_params
      params.require(:event).permit(:event_type_id, :date_time, :description, :notes)
    end
  end
end
