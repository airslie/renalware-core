module World
  module Pathology
    module Domain
      # @section commands

      def record_observations(patient:, observations_attributes:)
        patient = Renalware::Pathology.cast_patient(patient)

        observations_attributes.map! {|attrs|
          code = attrs.fetch("code")
          description = Renalware::Pathology::ObservationDescription.find_by(code: code)
          result = attrs.fetch("result")
          observed_at = Time.zone.parse(attrs.fetch("observed_at"))

          {description: description, result: result, observed_at: observed_at}
        }

        Renalware::Pathology::ObservationRequest.create!(
          patient: patient,
          requestor_name: "KCH",
          requested_at: Time.zone.now,
          description: Renalware::Pathology::RequestDescription.first!,
          observations_attributes: observations_attributes
        )
      end

      # @section expectations
      #
      def expect_observation_request_to_be_created(attrs)
        observation_request = find_last_observation_request

        expect_attributes_to_match(observation_request, attrs)
      end

      def expect_observations_to_be_created(rows)
        observation_request = find_last_observation_request

        expect(observation_request.observations.count).to eq(rows.size)
        expect_rows_to_match(observation_request.observations, rows)
      end

      def expect_rows_to_match(observations, rows)
        rows.each do |attrs|
          description_code = attrs.fetch("description")
          observation = find_observation(observations, description_code)

          expect_attributes_to_match(observation, attrs)
        end
      end

      def expect_attributes_to_match(record, expected_attrs)
        expected_attrs.each do |attr_name, expected_value|
          actual_value = record.public_send(attr_name).to_s
          expect(actual_value).to eq(expected_value)
        end
      end

      def expect_pathology_result_report(patient:, rows:)
        patient = Renalware::Pathology.cast_patient(patient)

        query = Renalware::Pathology::ArchivedResultsQuery.new(patient: patient).call
        _first, *observation_description_codes = rows.first.keys
        presenter = Renalware::Pathology::ArchivedResultsPresenter.new(
          query, observation_description_codes
        )

        expect(presenter.to_a).to match_array(rows)
      end

      private

      def find_last_observation_request
        Renalware::Pathology::ObservationRequest.includes(observations: :description).last!
      end

      def find_observation(observations, description_code)
        observations.detect { |obs| obs.description.code == description_code }
      end
    end
  end
end
