class EventsController < RenalwareController
  before_action :load_patient, :only => [:new, :create, :index]

  def new
    @event = Event.new
    @event_type = EventType.new
  end

  def create
    @event = Event.new(event_params)
    @event.patient_id = @patient.id
    if @event.save
      redirect_to patient_events_path(@patient), :notice => "You have successfully added an encounter/event."
    else
      render :new
    end
  end

  def index
    @event = Event.new
    @events = @patient.events
  end

  private
  def event_params
    params.require(:event).permit(:event_type_id, :date_time, :description, :notes)
  end
end
