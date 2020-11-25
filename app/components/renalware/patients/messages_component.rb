# frozen_string_literal: true

module Renalware
  module Patients
    class MessagesComponent < ApplicationComponent
      include ToggleHelper
      include Pagy::Backend
      include Pagy::Frontend
      TITLE = "Messages"

      rattr_initialize [:patient!, :current_user!]

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
          "#{TITLE} (#{pagination.count})"
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
        messaging_patient.messages.where(public: true).order(created_at: :desc)
      end
    end
  end
end
