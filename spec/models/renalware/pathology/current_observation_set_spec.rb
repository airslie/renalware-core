require "rails_helper"

module Renalware
  module Pathology
    RSpec.describe CurrentObservationSet do
      include PathologySpecHelper
      it { is_expected.to belong_to(:patient) }
      it { is_expected.to validate_presence_of(:patient) }

      describe "values" do
        it "defaults to an empty hash" do
          expect(described_class.new.values).to eq({})
        end

        it "persists ok" do
          patient = create(:pathology_patient)
          set = patient.fetch_current_observation_set
          hgb = { "result" => 23.1, "observed_at" => "2016-12-12 12:12:12" }
          set.values["HGB"] = hgb
          set.save!

          set.reload.values
          expect(set.values["HGB"]).to eq(hgb)
        end
      end

      # describe "#all" do
      #   it "returns only the most recent path results" do
      #     patient = create_patient
      #     descriptions = create_descriptions(%w(x y z))
      #     travel_to(Time.zone.now) do
      #       # current
      #       create_observations(patient,
      #                           descriptions,
      #                           observed_at: Time.zone.now,
      #                           result: 99)
      #       # !! not current
      #       create_observations(patient,
      #                           descriptions,
      #                           observed_at: Time.zone.now - 1.day,
      #                           result: 1)

      #       obs = patient.current_observations.all

      #       expect(obs.length).to eq(3)
      #       expect(obs.map(&:observed_at).uniq).to eq([Time.zone.now])
      #       expect(obs.map(&:result).uniq).to eq(["99"])
      #     end
      #  end
      # end
    end
  end
end
