# frozen_string_literal: true

require "renalware/letters/part"

module Renalware
  module Letters
    class Part
      attr_reader :patient, :letter, :event

      def initialize(patient, letter, event = Event::Unknown.new)
        @patient = patient
        @letter = letter
        @event = event
      end

      class << self
        def identifier
          name.demodulize.underscore.to_sym
        end

        def position
          10
        end
      end
    end
  end
end
