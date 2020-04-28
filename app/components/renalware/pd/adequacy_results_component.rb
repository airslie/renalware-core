# frozen_string_literal: true

require_dependency "renalware/surveys"

module Renalware
  module PD
    class AdequacyResultsComponent < ApplicationComponent
      include BooleanHelper
      include Pagy::Backend
      include Pagy::Frontend
      include ToggleHelper
      attr_reader :patient, :pagination

      TITLE = "Adequacy Results"

      def initialize(patient:)
        @patient = patient
      end

      def results
        @results ||= begin
          @pagination, @results = pagy(scope)
          # link_extra: "data-remote='true'"
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
        AdequacyResult.for_patient(patient).ordered
      end
    end
  end
end
