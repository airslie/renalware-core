class EventTypesController < RenalwareController

  def new
    @event_type = EventType.new
  end

  def create
    @event_type = EventType.new(allowed_params)
    if @event_type.save
      redirect_to event_types_path, :notice => "You have successfully added a new patient event type."
    else
      render :new
    end
  end

  def index
    @event_types = EventType.all
  end

  def edit
    @event_type = EventType.find(params[:id])
  end

  def update
    @event_type = EventType.find(params[:id])
    if @event_type.update(allowed_params)
      redirect_to event_types_path, :notice => "You have successfully updated patient event type"
    else
      render :edit
    end
  end

  def destroy
    EventType.destroy(params[:id])
    redirect_to event_types_path, :notice => "You have successfully removed a patient event type."
  end

  def allowed_params
    params.require(:event_type).permit(:name, :deleted_at)
  end
end
