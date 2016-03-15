module World
  module Pathology
    module Domain
      def expect_observation_request_to_be_created(expected_attributes)
        observation_request = find_last_observation_request

        expect_attributes(observation_request, expected_attributes)
      end

      def expect_observations_to_be_created(expected_rows)
        observation_request = find_last_observation_request

        expect(observation_request.observations.count).to eq(expected_rows.size)

        expected_rows.each do |expected_attributes|
          description_code = expected_attributes.fetch("description")
          observation = find_observation(observation_request.observations, description_code)

          expect_attributes(observation, expected_attributes)
        end
      end

      def find_last_observation_request
        Renalware::Pathology::ObservationRequest.includes(observations: :description).last!
      end

      def find_observation(observations, description_code)
        observations.find { |obs| obs.description.code == description_code }
      end

      def expect_attributes(record, expected_attributes)
        expected_attributes.each do |attribute_name, expected_value|
          actual_value = record.send(attribute_name).to_s
          expect(actual_value).to eq(expected_value)
        end
      end
    end
  end
end
