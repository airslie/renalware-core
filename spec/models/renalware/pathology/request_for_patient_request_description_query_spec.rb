# frozen_string_literal: true

require "rails_helper"

describe Renalware::Pathology::RequestForPatientRequestDescriptionQuery do
  let!(:clinic) { create(:clinic) }
  let!(:patient) { create(:pathology_patient) }
  let!(:consultant) { create(:pathology_consultant) }
  let!(:request_description) { create(:pathology_request_description) }
  let!(:request_description_unrelated) { create(:pathology_request_description) }

  let!(:request_newest_but_unrelated) do
    create(
      :pathology_requests_request,
      clinic: clinic,
      patient: patient,
      consultant: consultant,
      request_descriptions: [request_description_unrelated],
      created_at: Time.zone.now
    )
  end
  let!(:request_new) do
    create(
      :pathology_requests_request,
      clinic: clinic,
      patient: patient,
      consultant: consultant,
      request_descriptions: [request_description],
      created_at: Time.current - 1.day
    )
  end
  let!(:request_old) do
    create(
      :pathology_requests_request,
      clinic: clinic,
      patient: patient,
      consultant: consultant,
      request_descriptions: [request_description],
      created_at: Time.current - 2.days
    )
  end

  let(:query) do
    described_class.new(patient, request_description)
  end

  describe "#call" do
    subject(:resulting_request) { query.call }

    it { expect(resulting_request).to eq(request_new) }
  end
end
