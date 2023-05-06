# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Feeds::PatientLocator do
    describe ".strategy" do
      context "when strategy is configured as :dob_and_any_nhs_or_assigning_auth_number" do
        before do
          allow(Renalware.config)
            .to receive(:hl7_patient_locator_strategy)
            .and_return(:dob_and_any_nhs_or_assigning_auth_number)
        end

        it "returns the correct strategy class" do
          expect(described_class.strategy)
            .to eq(Renalware::Feeds::PatientLocatorStrategies::DobAndAnyNHSOrAssigningAuthNumber)
        end
      end

      context "when strategy is configured as :simple" do
        before do
          allow(Renalware.config)
            .to receive(:hl7_patient_locator_strategy)
            .and_return(:simple)
        end

        it "returns the correct strategy class" do
          expect(described_class.strategy)
            .to eq(Renalware::Feeds::PatientLocatorStrategies::Simple)
        end
      end

      context "when strategy is configured as :nhs_or_any_assigning_auth_number" do
        before do
          allow(Renalware.config)
            .to receive(:hl7_patient_locator_strategy)
            .and_return(:nhs_or_any_assigning_auth_number)
        end

        it "returns the correct strategy class" do
          expect(described_class.strategy)
            .to eq(Renalware::Feeds::PatientLocatorStrategies::NHSOrAnyAssigningAuthNumber)
        end
      end
    end
  end
end
