require "rails_helper"

module Renalware
  module Pathology
    RSpec.describe ObservationDateRange do
      describe "#call" do
        it "returns a range" do
          patient = create_patient
          create_observations_observed_at(
            patient, "2014-01-01", "2016-01-01", "2015-01-01", "2016-01-01", "2013-01-1"
          )

          expected_range = Range.new(Time.zone.parse("2013-01-01"), Time.zone.parse("2016-01-01"))
          expect(subject.call).to eq(expected_range)
        end
      end

      def create_patient
        patient = create(:patient)
        Pathology.cast_patient(patient)
      end

      def create_observations_observed_at(patient, *observation_dates)
        observation_dates.each do |observed_on|
          request = create(:pathology_observation_request, patient: patient)
          create(:pathology_observation, request: request, observed_at: observed_on)
        end
      end
    end
  end
end
