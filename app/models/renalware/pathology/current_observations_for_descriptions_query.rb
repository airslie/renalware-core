require_dependency "renalware/pathology"

module Renalware
  module Pathology
    # Responsible for finding the current observations for a patient for the
    # specified observation descriptions. It returns a result for each
    # observation description, nulls for missing observations for that
    # description.
    #
    # Note the query does not accept a relation as trying to compose it may break the
    # desired result set.
    #
    class CurrentObservationsForDescriptionsQuery
      def initialize(patient:, descriptions:)
        @patient = patient
        @descriptions = descriptions
      end

      def call
        Observation
          .select(<<-SQL)
            DISTINCT ON (pathology_observation_descriptions.id)
            pathology_observations.*,
            pathology_observation_descriptions.code AS description_code,
            pathology_observation_descriptions.name AS description_name
          SQL
          .joins(<<-SQL)
            LEFT JOIN pathology_observation_requests
            ON pathology_observations.request_id = pathology_observation_requests.id
          SQL
          .joins(<<-SQL)
            LEFT JOIN pathology_observation_descriptions
            ON pathology_observations.description_id = pathology_observation_descriptions.id
          SQL
          .order("pathology_observation_descriptions.id")
          .ordered
          .where(["pathology_observation_requests.patient_id = ? OR pathology_observation_requests.patient_id IS NULL", @patient.id])
          .where(pathology_observation_descriptions: { id: @descriptions })
      end
    end
  end
end
