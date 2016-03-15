module World
  module Pathology
    module Domain
      def expect_observation_request_to_be_created(expected_attributes)
        observation_request = fetch_last_observation_request

        expected_attributes.each do |attribute_name, expected_value|
          actual_value = observation_request.send(attribute_name).to_s
          expect(actual_value).to eq(expected_value)
        end
      end

      def fetch_last_observation_request
        Renalware::Pathology::ObservationRequest.last!
      end
    end
  end
end
