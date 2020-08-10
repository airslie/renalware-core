# frozen_string_literal: true

module Renalware
  module Patients
    class MessagesComponent < ApplicationComponent
      include ToggleHelper
      include Pagy::Backend
      include Pagy::Frontend
      TITLE = "Messages"

      attr_reader :patient, :current_user

      def initialize(patient:, current_user:)
        @patient = patient
        @current_user = current_user
      end

      def pagination
        load_messages unless @pagination
        @pagination
      end

      def messages
        load_messages unless @messages
        @messages
      end

      def title
        if pagination.items < pagination.count
          "#{TITLE} (#{pagination.items} of #{pagination.count})"
        else
          "#{TITLE} (#{pagination.items})"
        end
      end

      private

      def load_messages
        @pagination, @messages = pagy(scope, items: 5, link_extra: "data-remote='true'")
      end

      def messaging_patient
        @messaging_patient ||= Messaging.cast_patient(patient)
      end

      def scope
        messaging_patient.messages.order(created_at: :desc)
      end
    end
  end
end
