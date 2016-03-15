require "rails_helper"

module Renalware::Pathology
  RSpec.describe CreateObservations do
    describe "#call" do
      it "creates the request and related observations", :aggregate_failures do
        patient = pathology_patient(create(:patient))
        request_description = create(:pathology_request_description)
        observation_description = create(:pathology_observation_description)
        params = build_params(patient, request_description, observation_description)

        subject.call(params)

        expect(patient.observation_requests.count).to eq(1)
        expect(patient.observations.count).to eq(1)
      end

      def build_params(patient, request_description, observation_description)
        request_attrs = attributes_for(:pathology_observation_request)
          .merge(description_id: request_description.id)
        observation_attrs = attributes_for(:pathology_observation)
          .merge(description_id: observation_description.id)

        Hash.new.tap do |params|
          params[:patient_id] = patient.id
          params[:observation_request] = request_attrs
          params[:observation_request][:observations_attributes] = [observation_attrs]
        end
      end

      def pathology_patient(patient)
        Renalware::Pathology.cast_patient(patient)
      end
    end
  end
end
