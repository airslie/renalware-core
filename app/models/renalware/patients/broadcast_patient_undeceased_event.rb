module Renalware
  module Patients
    class BroadcastPatientUndeceasedEvent
      include Broadcasting

      def self.call(patient, reason = "")
        new
          .broadcasting_to_configured_subscribers
          .call(patient, reason)
      end

      def call(patient, reason)
        broadcast(:patient_undeceased, patient: patient, reason: reason)
      end
    end
  end
end
