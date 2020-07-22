# frozen_string_literal: true

module Renalware
  module Patients
    class MessagesComponent < ApplicationComponent
      include ToggleHelper

      pattr_initialize [:patient!, :current_user!]

      def messages
        messaging_patient.messages.order(created_at: :desc)
      end

      private

      def messaging_patient
        @messaging_patient ||= Messaging.cast_patient(patient)
      end
    end
  end
end
