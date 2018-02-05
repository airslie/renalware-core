require "rails_helper"

module Renalware::Pathology
  RSpec.describe ViewCurrentObservationResults do
    subject(:service) do
      ViewCurrentObservationResults.new(patient, presenter, descriptions: observation_descriptions)
    end

    let(:patient) { build(:patient) }
    let(:presenter) { spy(:presenter) }
    let(:observation_descriptions) { [build(:pathology_observation_description)] }

    describe "#call" do
      context "when patient has no observation requests" do
        it do
          results = service.call

          expect(presenter).to have_received(:present).with([])
          expect(results).to be_empty
        end
      end
    end
  end
end
