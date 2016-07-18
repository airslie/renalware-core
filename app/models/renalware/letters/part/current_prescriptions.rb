require "renalware/letters/part"

module Renalware
  module Letters
    class Part::CurrentPrescriptions < DumbDelegator
      def initialize(patient, _event = Event::Unknown.new)
        @patient = patient
        super(patient.prescriptions)
      end

      def to_partial_path
        "renalware/letters/parts/current_prescriptions"
      end
    end
  end
end
