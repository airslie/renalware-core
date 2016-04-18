require "array_stringifier"

module World
  module Pathology
    module RequestAlgorithm
      module Domain
        # @section commands

        def record_observations(patient:, observations_attributes:)

        end

        # @section expectations
        #
        def expect_observation_request_to_be_created(attrs)
          observation_request = find_last_observation_request

          expect_attributes_to_match(observation_request, attrs)
        end
      end
    end
  end
end
