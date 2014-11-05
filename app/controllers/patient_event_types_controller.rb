class PatientEventTypesController < ApplicationController

  def new
    @patient_event_type = PatientEventType.new
  end

  def create
    @patient_event_type = PatientEventType.new(allowed_params)
    if @patient_event_type.save
      redirect_to patient_event_types_path, :notice => "You have successfully added a new patient event type."
    else
      render :new
    end
  end

  def index
    @patient_event_types = PatientEventType.all
  end

  def edit 
    @patient_event_type = PatientEventType.find(params[:id])
  end

  def update
    @patient_event_type = PatientEventType.find(params[:id])
    if @patient_event_type.update(allowed_params)
      redirect_to patient_event_types_path, :notice => "You have successfully updated patient event type"
    else
      render :edit
    end
  end

  def destroy
    @patient_event_type = PatientEventType.find(params[:id])
    @patient_event_type.soft_delete!
    redirect_to patient_event_types_path, :notice => "You have successfully removed a patient event type."
  end 

  def allowed_params
    params.require(:patient_event_type).permit(:name, :deleted_at)
  end 

end
