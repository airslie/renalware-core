require "renalware/letters/part"

module Renalware
  module Letters
    class Part::CurrentMedications < DumbDelegator
      def initialize(patient, event = Event::Unknown.new)
        @patient = patient
        super(patient.medications)
      end

      def to_partial_path
        "renalware/letters/parts/current_medications"
      end
    end
  end
end
