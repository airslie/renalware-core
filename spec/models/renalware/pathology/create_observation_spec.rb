require "rails_helper"

module Renalware::Pathology
  RSpec.describe CreateObservations do
    describe "#call" do
      it "creates the request and related observations", :aggregate_failures do
        patient = pathology_patient(create(:patient))
        params = build_params(patient)

        subject.call(params)

        expect(patient.observation_requests.count).to eq(1)
        expect(patient.observations.count).to eq(1)
      end

      def build_params(patient)
        Hash.new.tap do |params|
          params[:patient_id] = patient.id
          params[:observation_request] = attributes_for(:pathology_observation_request)
          params[:observation_request][:observations_attributes] =
            [attributes_for(:pathology_observation)]
        end
      end

      def pathology_patient(patient)
        Renalware::Pathology.cast_patient(patient)
      end
    end
  end
end
