require "rails_helper"

describe Renalware::HD::ProtocolPresenter do
  describe "methods" do
    subject(:presenter) { described_class.new(nil, nil) }

    let(:patient) { nil }

    it { is_expected.to respond_to(:preference_set) }
    it { is_expected.to respond_to(:access) }
    it { is_expected.to respond_to(:sessions) }
    it { is_expected.to respond_to(:patient_title) }
    it { is_expected.to respond_to(:prescriptions) }
  end

  describe "#prescriptions" do
    it "returns only the patient's prescriptions that should be administered on HD" do
      patient = create(:hd_patient)
      create(:prescription, patient: patient, administer_on_hd: true)
      create(:prescription, patient: patient, administer_on_hd: false)
      presenter = described_class.new(patient, nil)

      presenter.prescriptions
      expect(presenter.prescriptions.length).to eq(1)
      expect(presenter.prescriptions.first.administer_on_hd).to be_truthy
    end
  end
end
