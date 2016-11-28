require "rails_helper"

module Renalware
  module PD
    describe SavePeritonitisEpisode do
      let(:patient) { create(:pd_patient) }
      let(:new_episode) { PeritonitisEpisode.new(patient_id: patient.id) }
      let(:existing_episode) { create(:peritonitis_episode, patient: patient) }
      subject { described_class.new(patient: patient, episode: episode) }
      let(:date) { Date.today }
      let(:episode_type_descriptions) do
        [
          create(:peritonitis_episode_type_description),
          create(:peritonitis_episode_type_description)
        ]
      end

      describe "#call" do

        context "when there are no validation errors" do
          let(:episode) { new_episode }

          it "saves a new episode and returns true" do
            params = { diagnosis_date: Date.today }
            expect(subject.call(params: params)).to eq(true)
          end

          it "saves a new episode and broadcasts success" do
            params = { diagnosis_date: Date.today }
            expect { subject.call(params: params) }.to broadcast(:save_success)
          end
        end

        context "when there are validation errors" do
          let(:episode) { new_episode }

          it "returns false" do
            params = { diagnosis_date: nil }
            expect(subject.call(params: params)).to eq(false)
          end

          it "broadcasts failure" do
            params = { diagnosis_date: nil }
            expect { subject.call(params: params) }.to broadcast(:save_failure)
          end
        end

        context "updating an existing episode" do
          let(:episode) { existing_episode }

          it "updates an existing episode" do
            params = { diagnosis_date: date }

            success = subject.call(params: params)

            expect(success).to eq(true)
            expect(patient.peritonitis_episodes.count).to eq(1)
            expect(patient.peritonitis_episodes.first.diagnosis_date).to eq(date)
          end

          it "saves all episode#episode_types" do
            expected_description_ids = episode_type_descriptions.map(&:id)
            params = { diagnosis_date: date, episode_types: expected_description_ids }

            success = subject.call(params: params)

            expect(success).to eq(true)
            episode = patient.peritonitis_episodes.first
            description_ids = episode.episode_types.map(&:peritonitis_episode_type_description_id)
            expect(description_ids.sort).to eq(expected_description_ids.sort)
          end

          it "clears all episode_types if none supplied" do
            episode = existing_episode
            episode.episode_types.create(
              peritonitis_episode_type_description_id: episode_type_descriptions.first.id
            )
            params = { diagnosis_date: date, episode_types: [] }

            success = subject.call(params: params)

            expect(success).to eq(true)
            episodes = patient.peritonitis_episodes
            expect(episodes.count).to eq(1)
            episode = episodes.first
            expect(episode.episode_types).to eq []
          end
        end
      end
    end
  end
end
