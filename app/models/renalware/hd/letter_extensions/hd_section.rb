# frozen_string_literal: true

require "renalware/letters/part"

module Renalware
  module HD
    module LetterExtensions
      class HDSection < ::Renalware::Letters::Part
        def initialize(patient, _letter, _event = Event::Unknown.new)
          @patient = patient
        end

        def to_partial_path
          "renalware/hd/letter_extensions/hd_section"
        end
      end
    end
  end
end
