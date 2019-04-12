# frozen_string_literal: true

require_dependency "renalware/ukrdc"
require "attr_extras"

module Renalware
  module UKRDC
    class PathologyObservationRequestsQuery
      pattr_initialize [:patient_id!, :changes_since!]

      def call
        observation_requests
      end

      private

      def observation_requests
        Pathology::ObservationRequest
          .where(id: Pathology::ObservationRequest.distinct_for_patient_id(patient_id))
          .where("requested_at >= ?", changes_since)
          .where("loinc_code is not null")
          .eager_load(
            :description,
            observations: { description: :measurement_unit }
          )
      end
    end
  end
end
