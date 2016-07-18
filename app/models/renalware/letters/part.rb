require "renalware/letters/part"

module Renalware
  module Letters
    class Part
      attr_reader :patient, :event

      def initialize(patient, event)
        @patient = patient
        @event = event
      end
    end
  end
end
