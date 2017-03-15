require_dependency "renalware/events"

module Renalware
  module Events
    class EventsController < BaseController
      before_action :load_patient, only: [:new, :create, :index]

      def new
        session[:return_to] ||= request.referer
        render locals: {
          patient: patient,
          event: build_new_event,
          event_types: event_types
        }
      end

      def create
        event = new_event_for_patient(event_params)
        if event.save
          return_url = session.delete(:return_to) || patient_events_path(patient)
          redirect_to return_url, notice: t(".success", model_name: "event")
        else
          flash[:error] = t(".failed", model_name: "event")
          render :new, locals: {
            patient: patient,
            event: event,
            event_types: event_types
          }
        end
      end

      def index
        render locals: {
          patient: patient,
          events: events
        }
      end

      private

      def events
        Event.for_patient(patient)
             .includes(:event_type)
             .includes(:created_by)
             .page(params[:page])
             .per(params[:per_page])
             .ordered
      end

      def disable_selection_of_event_type?
        event_type_slug.present? && event_type.present?
      end

      def build_new_event
        event = new_event_for_patient
        event.date_time = Time.zone.now.beginning_of_hour
        event.event_type = event_type
        # This is a virtual attribute
        event.disable_selection_of_event_type = disable_selection_of_event_type?
        event
      end

      def event_class
        event_type.event_class_name.constantize
      end

      def event_type
        return Events::Type.find(event_type_id) if event_type_id.present?
        return Events::Type.find_by!(slug: event_type_slug) if event_type_slug.present?
        Events::Type.new
      end

      def event_type_id
        @event_type_id ||= begin
          return event_params[:event_type_id] if params[:events_event]
          params[:event_type_id]
        end
      end

      def event_type_slug
        params[:slug]
      end

      def event_params
        params.require(:events_event)
              .permit(:event_type_id, :date_time, :description, :notes,
                      :disable_selection_of_event_type, document: [])
              .merge!(document: document_attributes)
              .merge!(by: current_user)
      end

      def document_attributes
        params.require(:events_event)
              .fetch(:document, nil).try(:permit!)
      end

      def new_event_for_patient(params = {})
        event = event_class.new
        event.attributes = params
        event.patient = patient
        event
      end

      def event_types
        Renalware::Events::Type.order(:name).map do |event_type|
          [
            event_type.name,
            event_type.id,
            {
              data: {
                source: new_patient_event_path(patient, event_type_id: event_type.id, format: :js)
              }
            }
          ]
        end
      end
    end
  end
end
