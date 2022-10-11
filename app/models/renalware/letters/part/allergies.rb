# frozen_string_literal: true

require "renalware/letters/part"

# Decorates an a Clinical::Patient so we can access patient.allergies in the view
module Renalware
  module Letters
    class Part::Allergies < Part
      attr_reader :allergy_status, :patient

      def initialize(patient, _letter, _event = Event::Unknown.new)
        @patient = ::Renalware::Clinical.cast_patient(patient.__getobj__)
        @allergy_status = @patient.allergy_status
      end

      def to_partial_path
        "renalware/letters/parts/allergies"
      end

      delegate :allergies, to: :patient
      delegate_missing_to :allergies
    end
  end
end
