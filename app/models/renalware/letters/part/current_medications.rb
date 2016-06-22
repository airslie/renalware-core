require "renalware/letters/part"

module Renalware
  module Letters
    class Part::CurrentMedications < DumbDelegator
      def initialize(patient)
        @patient = patient
        super(patient.medications)
      end
    end
  end
end
