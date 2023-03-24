# frozen_string_literal: true

require "rails_helper"

module Renalware::Medications
  describe PrescriptionFormPresenter do
    let(:prescription) { Prescription.new }
    let(:selected_drug_id) { "21" }

    let(:instance) {
      described_class.new(
        prescription: prescription,
        selected_drug_id: selected_drug_id
      )
    }

    describe "#frequencies" do
      let(:frequency) { create(:drug_frequency, name: "test") }

      it "includes 'Other' as frequency" do
        expect(instance.frequencies.size).to eq 1
        expect(instance.frequencies[0].name).to eq "other"
      end

      context "when Frequency row is present" do
        before do
          frequency
        end

        it "includes the frequencies + other" do
          expect(instance.frequencies.size).to eq 2
          expect(instance.frequencies[0].name).to eq "test"
          expect(instance.frequencies[1].name).to eq "other"
        end
      end
    end
  end
end
