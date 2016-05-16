require "rails_helper"

describe Renalware::Pathology::ObservationForPatientObservationDescriptionQuery do
  let(:patient) { Renalware::Pathology.cast_patient(build(:patient)) }
  let(:description) { build(:pathology_observation_description) }

  subject(:query) do
    Renalware::Pathology::ObservationForPatientObservationDescriptionQuery.new(
      patient,
      description
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

    it "returns the most recent observation for the specified observation description" do
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
