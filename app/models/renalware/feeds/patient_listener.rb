# frozen_string_literal: true

module Renalware
  module Feeds
    class PatientListener
      def patient_added(patient)
        ReplayHistoricalHL7Messages.call(patient)
      end
    end
  end
end
