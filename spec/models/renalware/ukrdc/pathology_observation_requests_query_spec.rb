# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe UKRDC::PathologyObservationRequestsQuery do
    include PathologySpecHelper
    let(:patient) { create(:pathology_patient) }

    describe "#call" do
      subject(:query) { described_class.new(patient_id: patient.id, changes_since: changes_since) }

      let(:changes_since) { "2018-01-01" }

      context "when the patient has no pathology" do
        it "returns empty-handed" do
          expect(query.call).to eq []
        end
      end

      context "when the patient has OBRs outside of the requested date range" do
        let(:changes_since) { 2.days.ago }

        it "ignores these" do
          _old_request = create_request_with_observations(
            requested_at: 3.days.ago,
            patient: patient
          )
          recent_request = create_request_with_observations(
            requested_at: 1.day.ago,
            patient: patient
          )

          expect(query.call).to eq [recent_request]
        end
      end

      context "when the patient has OBRs outside of the requested date range" do
        let(:changes_since) { 1.day.ago }

        it "ignores these" do
          create_request_with_observations(requested_at: 2.days.ago, patient: patient)
          expect(query.call).to eq []
        end
      end

      context "when the patient has had an OBR and a then an update to that OBR" do
        it "uses Pathology::ObservationRequest#distinct_for_patient_id to ensure it always gets "\
           "the most recently received version of any observation request" do
          allow(Pathology::ObservationRequest)
            .to receive(:distinct_for_patient_id).with(patient.id)

          query.call

          expect(Pathology::ObservationRequest)
            .to have_received(:distinct_for_patient_id).with(patient.id)
        end
      end
    end
  end
end
