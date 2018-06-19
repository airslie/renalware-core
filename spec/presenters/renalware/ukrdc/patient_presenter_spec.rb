# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe UKRDC::PatientPresenter do
    def smoker(status)
      patient = Patient.new(sent_to_ukrdc_at: 1.year.ago)
      patient.document.history.smoking = status
      UKRDC::PatientPresenter.new(patient).smoking_history
    end

    describe "#smoking_history" do
      it "converts RW enums to RRSMOKING codes" do
        expect(smoker(:no)).to eq("NO")
        expect(smoker(:yes)).to eq("YES")
        expect(smoker(:ex)).to eq("EX")
      end
    end

    describe "#langauge" do
      subject(:presenter) { described_class.new(patient).language }

      let(:patient) do
        build_stubbed(:patient, language: language, sent_to_ukrdc_at: 1.year.ago)
      end

      context "when the patient has the language Unknown which is not in ISO 639" do
        let(:language) { build_stubbed(:language, :unknown) }

        it { is_expected.not_to be_present }
      end

      context "when the patient has the language Afrikaans" do
        let(:language) { build_stubbed(:language, :afrikaans) }

        it { is_expected.to be_present }
      end

      context "when the patient has no language" do
        let(:language) { nil }

        it { is_expected.not_to be_present }
      end
    end
  end
end
