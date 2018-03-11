# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Pathology
    RSpec.describe CreateObservationsGroupedByDateTable do
      let(:options) { {} }
      let(:patient) { create(:pathology_patient) }
      let(:another_patient) { create(:pathology_patient) }
      let(:observation_descriptions) { [] }

      context "when the patient has had path results on several dates in the past" do
        it "creates a paginated table object" do
          Observation.delete_all
          ObservationRequest.delete_all
          RequestDescription.delete_all
          ObservationDescription.delete_all

          dates = [
            Time.zone.parse("2018-01-01 12:12:12"),
            Time.zone.parse("2017-09-01 12:12:12"),
            Time.zone.parse("2017-07-01 12:12:12"),
            Time.zone.parse("2017-01-01 12:12:12")
          ]

          create(
            :pathology_observation_request,
            :full_blood_count_with_observations,
            patient: patient,
            requested_at: dates[0]
          )

          create(
            :pathology_observation_request,
            :full_blood_count_with_observations,
            patient: patient,
            requested_at: dates[1]
          )

          create(
            :pathology_observation_request,
            :renal_live_urea_with_observations,
            patient: patient,
            requested_at: dates[2]
          )

          create(
            :pathology_observation_request,
            :renal_live_urea_with_observations,
            patient: patient,
            requested_at: dates[3]
          )

          # Sanity check!
          # There should be a certain number of observations over our chosen dates
          expect(patient.reload.observations.count).to eq(12)
          expect(
            patient
              .reload
              .observations
              .order(observed_at: :desc)
              .select(:observed_at)
              .group(:observed_at)
              .pluck(:observed_at)
              .map(&:round)
          ).to eq(dates)

          descriptions = ObservationDescription.select(:id, :code).all
          expect(descriptions.map(&:code).sort).to match_array(%w(HGB NA PLT POT URE WBC))

          service = described_class.new(
            patient: patient,
            observation_descriptions: descriptions,
            per_page: 3,
            page: 1
          )

          table = service.call

          # pagination
          expect(table.total_pages).to eq(2)
          expect(table.current_page).to eq(1)

          expect(table.rows.count).to eq(3)
          expect(table.rows.map(&:observed_on)).to eq(dates[0..2].map(&:to_date))
          expect(table.rows.map(&:results)).to eq(
            [
              { "HGB" => "6.0", "PLT" => "6.0", "WBC" => "6.0" },
              { "HGB" => "6.0", "PLT" => "6.0", "WBC" => "6.0" },
              { "NA" => "1.0", "POT" => "1.0", "URE" => "1.0" }
            ]
          )
        end
      end
    end
  end
end
