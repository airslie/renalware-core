require "rails_helper"

module Renalware::Pathology
  RSpec.describe ViewCurrentObservationResults do
    let(:patient) { build(:patient) }
    let(:presenter) { spy(:presenter) }
    let(:observation_descriptions) { [build(:pathology_observation_description)] }

    subject(:service) { ViewCurrentObservationResults.new(patient, presenter, descriptions: observation_descriptions) }

    describe "#call" do
      context "given a patient has no observation requests" do
        it do
          results = service.call

          expect(presenter).to have_received(:present).with([])
          expect(results).to be_empty
        end
      end
    end
  end
end
