require "rails_helper"

describe Renalware::Pathology::ObservationForPatientQuery do
  let!(:patient) { Renalware::Pathology.cast_patient(create(:patient)) }
  let!(:observation_description) { create(:pathology_observation_description) }
  subject do
    Renalware::Pathology::ObservationForPatientQuery.new(
      patient,
      observation_description.id
    )
  end

  describe "#call" do
    let!(:observation_request_1) { create(:pathology_observation_request, patient: patient) }
    let!(:observation_1) do
      create(
        :pathology_observation,
        request: observation_request_1,
        description: observation_description,
        observed_at: Time.now - 1.week
      )
    end
    let!(:observation_request_2) { create(:pathology_observation_request, patient: patient) }
    let!(:observation_2) do
      create(
        :pathology_observation,
        request: observation_request_2,
        description: observation_description,
        observed_at: Time.now - 2.week
      )
    end
    let!(:observation_3) { create(:pathology_observation, request: observation_request_2) }

    it { expect(subject.call).to eq(observation_1) }
  end
end
