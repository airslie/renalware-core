# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/MultipleMemoizedHelpers
module Renalware
  module Pathology
    describe Generators::UrrGenerator do
      let(:patient) { create(:pathology_patient) }
      let(:obr_desc) { create(:pathology_request_description, code: "UE") }
      let(:obx_desc_pre_urea) { create(:pathology_observation_description, code: "URE") }
      let(:obx_desc_post_urea) { create(:pathology_observation_description, code: "P_URE") }
      let(:obx_desc_urr) { create(:pathology_observation_description, code: "URR") }
      let(:datetime) { DateTime.parse("2001-01-01 14:00:00") }

      def create_pre_urea(observed_at, value)
        create(
          :pathology_observation,
          description: obx_desc_pre_urea,
          observed_at: observed_at,
          request: create(:pathology_observation_request, description: obr_desc, patient: patient),
          result: value
        )
      end

      def create_post_urea(obr, observed_at, value)
        create(
          :pathology_observation,
          description: obx_desc_post_urea,
          observed_at: observed_at,
          result: value,
          request: obr
        )
      end

      before do
        obx_desc_urr
        Renalware.configure do |config|
          config.pathology_hours_to_search_behind_for_pre_ure_result = 6
          config.pathology_hours_to_search_ahead_for_pre_ure_result = 4
        end
      end

      describe "looks for a post-HD urea eg P_URE and returns this + the closest pre-hd Urea" do
        [
          {
            post_urea: {
              observed_at: ->(dt) { dt },
              value: 10
            },
            pre_urea: [
              {
                observed_at: ->(dt) { dt - 1.hour },
                value: 20,
                target: true
              },
              {
                observed_at: ->(dt) { dt - 2.hours },
                value: 30
              },
              {
                observed_at: ->(dt) { dt + 61.minutes },
                value: 30
              }
            ],
            expected_urr_count: 1,
            expected_urr: 50 # post: 10 pre: 20
          },
          {
            post_urea: {
              observed_at: ->(dt) { dt },
              value: 11 # bigger not smaller than pre, so will not result in a urr
            },
            pre_urea: [
              {
                observed_at: ->(dt) { dt - 1.hour },
                value: 10
              }
            ],
            expected_urr_count: 0,
            expected_urr: 0
          },
          {
            post_urea: {
              observed_at: ->(dt) { dt },
              value: 10
            },
            pre_urea: [
              {
                observed_at: ->(dt) { dt - 7.hours }, # outside the window
                value: 20,
                target: true
              },
              {
                observed_at: ->(dt) { dt + 5.hours }, # outside the window
                value: 30
              }
            ],
            expected_urr_count: 0,
            expected_urr: 0
          }
        ].each do |test|
          it do
            obr = create(:pathology_observation_request, description: obr_desc, patient: patient)
            create_post_urea(
              obr,
              test[:post_urea][:observed_at].call(datetime),
              test[:post_urea][:value]
            )

            test[:pre_urea].each do |pre|
              create_pre_urea(
                pre[:observed_at].call(datetime),
                pre[:value]
              )
            end

            expect {
              described_class.call
            }.to change(Observation, :count).by(test[:expected_urr_count])

            if test[:expected_urr_count] > 0
              urr = patient.observations.where(description: obx_desc_urr).last
              expect(urr.nresult).to eq(test[:expected_urr])
            end

            # Check that once the URR is created, it does not re-create it.
            expect { described_class.call }.not_to change(Observation, :count)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
