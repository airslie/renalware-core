require_dependency "renalware/events"

module Renalware
  module Events
    class EventsController < BaseController
      before_action :load_patient, only: [:new, :create, :index]

      def new
        @event = new_event_for_patient
        @event_type = Type.new
      end

      def create
        @event = new_event_for_patient(event_params)
        if @event.save
          redirect_to patient_events_path(@patient),
            notice: t(".success", model_name: "event")
        else
          flash[:error] = t(".failed", model_name: "event")
          render :new
        end
      end

      def index
        @events = Event.for_patient(@patient)
      end

      private

      def event_params
        params.require(:events_event).permit(:event_type_id, :date_time, :description, :notes)
      end

      def new_event_for_patient(params={})
        Event.new(params) do |e|
          e.patient = @patient
        end
      end
    end
  end
end
