# frozen_string_literal: true

require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationForPatientObservationDescriptionUsingSetQuery
      pattr_initialize :patient, :observation_description

      # Fetches the patient's most recent observation for the supplied observation_description.code
      # (eg 'HGB') using the patient's current_observation_set jsonb hash and returnd something
      # like { "result" => "123", "observed_on" => "2019-01-01" }
      def call
        return {} unless patient.current_observation_set

        patient.current_observation_set.values.fetch(observation_description.code, {})
      end
    end
  end
end