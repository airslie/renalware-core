# frozen_string_literal: true

require_dependency "renalware/surveys"

module Renalware
  module PD
    class PETResultsComponent < ApplicationComponent
      include Pagy::Backend
      include Pagy::Frontend
      attr_reader :patient, :pagination

      TITLE = "PET Results"

      def initialize(patient:)
        @patient = PD.cast_patient(patient)
      end

      def results
        @results ||= begin
          @pagination, @results = pagy(scope)
          @results
        end
      end

      def title
        if pagination.items < pagination.count
          "#{TITLE} (#{pagination.items} of #{pagination.count})"
        else
          "#{TITLE} (#{pagination.items})"
        end
      end

      private

      def scope
        patient.pet_results.ordered
      end
    end
  end
end
