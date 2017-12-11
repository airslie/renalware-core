require "rails_helper"

module Renalware::Pathology
  RSpec.describe Patient do
    it { is_expected.to have_one(:current_observation_set) }

    describe ".fetch_current_observation_set" do
      context "when the patient doesn't have one" do
        it "build an one ready for saving" do
          patient = create(:pathology_patient)

          set = patient.fetch_current_observation_set

          expect(set).to be_present
          expect(set).not_to be_persisted
        end
      end
      context "when the patient already has one" do
        it "it returns the existing one" do
          patient = create(:pathology_patient)
          set = patient.build_current_observation_set

          set.save!

          set = patient.fetch_current_observation_set
          expect(set).to be_persisted
        end
      end
    end
  end
end
