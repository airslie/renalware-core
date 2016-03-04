require "rails_helper"

module Renalware::Pathology
  RSpec.describe CreateObservations do
    describe "#call" do
      it "creates the request and related observations", :aggregate_failures do
        params = {}
        params[:observation_request] = attributes_for(:pathology_observation_request)
        params[:observation_request][:observations_attributes] =
          [attributes_for(:pathology_observation)]

        subject.call(params)

        expect(ObservationRequest.count).to eq(1)
        expect(Observation.count).to eq(1)
      end
    end
  end
end
