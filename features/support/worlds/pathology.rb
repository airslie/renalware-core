require "array_stringifier"

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

          { description: description, result: result, observed_at: observed_at }
        }

        Renalware::Pathology::ObservationRequest.create!(
          patient: patient,
          requestor_name: "KCH",
          requested_at: Time.zone.now,
          description: Renalware::Pathology::RequestDescription.first!,
          observations_attributes: observations_attributes
        )
      end

      def create_request(patient:, description_code: , requested_at:)
        patient = Renalware::Pathology.cast_patient(patient)
        description = Renalware::Pathology::RequestDescription.find_by(code: description_code)

        Renalware::Pathology::ObservationRequest.create!(
          patient: patient,
          requestor_name: "KCH",
          requested_at: requested_at,
          description: description,
        )
      end

      def create_observation(request:, description_code:, observed_at:)
        description = Renalware::Pathology::ObservationDescription.find_by(code: description_code)

        Renalware::Pathology::Observation.create!(
          request: request,
          description: description,
          observed_at: observed_at,
          result: "100"
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

      def expect_pathology_recent_observations(user:, patient:, rows:)
        patient = Renalware::Pathology.cast_patient(patient)
        codes = rows.slice(2..-1).map(&:first)
        descriptions = Renalware::Pathology::ObservationDescription.for(codes)

        presenter = Renalware::Pathology::RecentObservationResults::Presenter.new
        service = Renalware::Pathology::ViewObservationResults.new(
          patient.observations, presenter, descriptions: descriptions)
        service.call
        view = ArrayStringifier.new(presenter.view_model).to_a

        expect(view).to match_array(rows)
      end

      def expect_pathology_historical_observations(user:, patient:, rows:)
        patient = Renalware::Pathology.cast_patient(patient)
        codes = rows.first[1..-1]
        descriptions = Renalware::Pathology::ObservationDescription.for(codes)

        presenter = Renalware::Pathology::HistoricalObservationResults::Presenter.new
        service = Renalware::Pathology::ViewObservationResults.new(
          patient.observations, presenter, descriptions: descriptions)
        service.call
        view = ArrayStringifier.new(presenter.view_model).to_a

        expect(view).to match_array(rows)
      end

      def expect_pathology_current_observations(user:, patient:, rows:)
        patient = Renalware::Pathology.cast_patient(patient)
        codes = rows.map {|row| row.first }[1..-1]
        descriptions = Renalware::Pathology::ObservationDescription.for(codes)

        presenter = Renalware::Pathology::CurrentObservationResults::Presenter.new
        service = Renalware::Pathology::ViewCurrentObservationResults.new(
          patient, presenter, descriptions: descriptions)
        service.call
        view = ArrayStringifier.new(presenter.view_model).to_a

        expect(view).to match_array(rows)
      end

      private

      def find_last_observation_request
        Renalware::Pathology::ObservationRequest.includes(observations: :description).last!
      end

      def find_observation(observations, description_code)
        observations.detect { |obs| obs.description.code == description_code }
      end
    end

    module Web
      include Domain

      def html_table_to_array(table_id)
        find_by_id(table_id)
          .all("tr")
          .map do |row|
            row.all("th, td").map { |cell| cell.text.strip }
          end
      end

      def expect_pathology_recent_observations(user:, patient:, rows:)
        login_as user

        visit patient_pathology_recent_observations_path(patient)

        expect(page).to have_selector("table#observations tr:first-child td", count: 4)
      end

      def expect_pathology_historical_observations(user:, patient:, rows:)
        login_as user

        visit patient_pathology_historical_observations_path(patient)

        expect(page).to have_selector("table#observations tr", count: rows.size)
      end

      def expect_pathology_current_observations(user:, patient:, rows:)
        login_as user

        visit patient_pathology_current_observations_path(patient)

        number_of_observation_descriptions = Renalware::Pathology::RelevantObservationDescription.codes.size
        expect(page).to have_selector("table.current-observations tbody tr", count: number_of_observation_descriptions)
      end
    end
  end
end

Dir[Rails.root.join("features/support/worlds/pathology/*.rb")].each { |f| require f }
