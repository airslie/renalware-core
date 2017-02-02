require "rails_helper"

describe Renalware::HD::ProtocolPresenter do
  describe "methods" do
    let(:patient) { nil }
    subject(:presenter) { Renalware::HD::ProtocolPresenter.new(nil, nil) }
    it { is_expected.to respond_to(:preference_set) }
    it { is_expected.to respond_to(:access) }
    it { is_expected.to respond_to(:sessions) }
    it { is_expected.to respond_to(:patient_title) }
    it { is_expected.to respond_to(:prescriptions) }
  end

  describe "#prescriptions" do
    it "returns only the patient's prescriptions that should be administered on HD" do
      patient = create(:hd_patient)
      presenter = Renalware::HD::ProtocolPresenter.new(patient, nil)

      expect(patient.prescriptions).to receive(:to_be_administered_on_hd)
      presenter.prescriptions
    end
  end
end
