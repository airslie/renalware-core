require "renalware/letters/part"

module Renalware
  module Letters
    class Part
      attr_reader :patient, :letter, :event

      def initialize(patient, letter, event)
        @patient = patient
        @letter = letter
        @event = event
      end
    end
  end
end
