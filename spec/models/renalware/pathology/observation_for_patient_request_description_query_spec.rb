# frozen_string_literal: true

require "rails_helper"

describe Renalware::Pathology::ObservationForPatientRequestDescriptionQuery do
  describe "#call" do
    it "returns the most recent observation for the specified request description" do
      patient_a = Renalware::Pathology.cast_patient(create(:patient))
      patient_b = Renalware::Pathology.cast_patient(create(:patient))
      description = create(:pathology_observation_description)
      request_description_a = create(
        :pathology_request_description,
        required_observation_description: description
      )
      create_observation(patient: patient_b, description: description, observed_at: 2.weeks.ago)
      create_observation(patient: patient_a, description: description, observed_at: 2.weeks.ago)
      most_recent_observation = create_observation(
        patient: patient_a,
        description: description,
        observed_at: 1.week.ago
      )

      query = described_class.new(patient_a, request_description_a)

      expect(query.call).to eq(most_recent_observation)
    end
  end
end

def create_observation(patient:, description:, observed_at:)
  request = create(:pathology_observation_request, patient: patient)
  create(
    :pathology_observation,
    request: request,
    description: description,
    observed_at: observed_at
  )
end
