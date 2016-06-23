require "renalware/letters/part"

module Renalware
  module Letters
    class Part::Problems < DumbDelegator
      def initialize(patient, _event)
        @patient = patient
        super(patient.problems)
      end

      def to_partial_path
        "renalware/letters/parts/problems"
      end
    end
  end
end
