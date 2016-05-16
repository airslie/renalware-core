require "rails_helper"

describe Renalware::Pathology::ObservationForPatientRequestDescriptionQuery do
  let!(:patient) { Renalware::Pathology.cast_patient(create(:patient)) }
  let!(:description) { create(:pathology_observation_description) }
  let!(:request_description) do
    create(
      :pathology_request_description,
      required_observation_description: description
    )
  end

  subject(:query) do
    Renalware::Pathology::ObservationForPatientRequestDescriptionQuery.new(
      patient,
      request_description
    )
  end

  describe "#call" do
    let!(:most_recent_observation) do
      create_observation(patient: patient, description: description, observed_at: 1.week.ago)
    end
    let!(:older_observation) do
      create_observation(patient: patient, description: description, observed_at: 2.weeks.ago)
    end
    let!(:unrelated_observation) { create(:pathology_observation) }

    subject(:query_result) { query.call }

    it "returns the most recent observation for the specified request description" do
      expect(query_result).to eq(most_recent_observation)
    end
  end
end

def create_observation(patient:, description:, observed_at:)
  request = create(:pathology_observation_request, patient: patient)
  create(:pathology_observation,
   request: request,
   description: description,
   observed_at: observed_at
 )
end
