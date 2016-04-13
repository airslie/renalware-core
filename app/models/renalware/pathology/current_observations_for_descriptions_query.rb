require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class CurrentObservationsForDescriptionsQuery
      def initialize(relation: Observation.all, descriptions:)
        @relation = relation
        @descriptions = descriptions
      end

      def call
        @relation
          .select(<<-SQL)
            DISTINCT ON (pathology_observations.description_id)
            pathology_observations.*,
            pathology_observation_descriptions.code AS description_code,
            pathology_observation_descriptions.name AS description_name
           SQL
          .joins(<<-SQL)
            RIGHT JOIN pathology_observation_descriptions
            ON pathology_observations.description_id = pathology_observation_descriptions.id
          SQL
          .where(pathology_observation_descriptions: {id: @descriptions})
          .order("pathology_observations.description_id")
          .ordered
      end
    end
  end
end
