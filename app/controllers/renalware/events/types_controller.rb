# frozen_string_literal: true

require_dependency "renalware/events"

module Renalware
  module Events
    class TypesController < BaseController
      def new
        event_type = Type.new
        authorize event_type
        render locals: { event_type: event_type }
      end

      def create
        event_type = Type.new(event_params)
        authorize event_type
        if event_type.save
          redirect_to events_types_path, notice: success_msg_for("event type")
        else
          flash.now[:error] = failed_msg_for("event type")
          render :new, locals: { event_type: event_type }
        end
      end

      def index
        event_types = Type.all
        authorize event_types
        render locals: { event_types: event_types }
      end

      def edit
        event_type = load_and_authorize_event_type
        render locals: { event_type: event_type }
      end

      def update
        event_type = load_and_authorize_event_type
        if event_type.update(event_params)
          redirect_to events_types_path, notice: success_msg_for("event type")
        else
          flash.now[:error] = failed_msg_for("event type")
          render :edit, locals: { event_type: event_type }
        end
      end

      def destroy
        event_type = load_and_authorize_event_type
        event_type.destroy
        redirect_to events_types_path, notice: success_msg_for("event type")
      end

      private

      def event_params
        params.require(:events_type).permit(:name, :deleted_at)
      end

      def load_and_authorize_event_type
        event_type = Type.find(params[:id])
        authorize event_type
        event_type
      end
    end
  end
end
