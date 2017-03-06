require "rails_helper"

module Renalware
  module Pathology

    RSpec.describe CurrentKeyObservationSet do
      include PathologySpecHelper

      it { is_expected.to belong_to(:patient) }

      describe "#all" do
        it "returns recent obs" do
          patient = create_patient
          descriptions = create_descriptions(%w(HGB MDRD CRE URE))

          travel_to(Time.zone.now) do

            # current
            create_observations(patient,
                                descriptions,
                                observed_at: Time.zone.now,
                                result: 99)
            # !! not current
            create_observations(patient,
                                descriptions,
                                observed_at: Time.zone.now - 1.day,
                                result: 1)

            obs = patient.current_key_observation_set

            expect(obs.hgb_result.to_i).to eq(99)
            expect(obs.hgb_observed_at).to eq(Time.zone.now)
            expect(obs.mdrd_result.to_i).to eq(99)
            expect(obs.mdrd_observed_at).to eq(Time.zone.now)
            expect(obs.cre_result.to_i).to eq(99)
            expect(obs.cre_observed_at).to eq(Time.zone.now)
            expect(obs.ure_result.to_i).to eq(99)
            expect(obs.ure_observed_at).to eq(Time.zone.now)
          end
        end
      end
    end
  end
end
