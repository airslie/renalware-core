# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Medications
    describe PrescriptionPresenter do
      let(:instance) {      described_class.new(prescription) }

      describe "#frequency" do
        let(:prescription) { Prescription.new(frequency: "test", frequency_comment: "abc") }

        subject { instance.frequency }

        before do
          allow(Drugs::Frequency).to receive(:title_for_name).with("test").and_return("TEST")
        end

        it { is_expected.to eq "TEST abc" }
      end
    end
  end
end
