# frozen_string_literal: true

module Renalware
  describe UKRDC::RenalRegistryId do
    subject(:renal_registry_id) { described_class.new(patient:).to_s }

    before do
      allow(Renalware.config).to receive(:ukrdc_sending_facility_name).and_return("RAJ")
    end

    context "when the patient has a renal_registry_id" do
      let(:patient) { Patient.new(renal_registry_id: "aAB13bd456") }

      it { is_expected.to eq("RAJ_aAB13bd456") }
    end

    context "when the patient does not have a renal_registry_id" do
      let(:patient) { Patient.new(renal_registry_id: nil) }

      it { is_expected.to eq("") }
    end
  end
end
