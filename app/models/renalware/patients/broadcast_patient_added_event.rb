# frozen_string_literal: true

module Renalware
  module Patients
    class BroadcastPatientAddedEvent
      include Broadcasting

      def self.call(patient)
        new
          .broadcasting_to_configured_subscribers
          .call(patient)
      end

      def call(patient)
        broadcast(:patient_added, patient)
      end
    end
  end
end
