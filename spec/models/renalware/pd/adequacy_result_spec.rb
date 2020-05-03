# frozen_string_literal: true

require "rails_helper"

module Renalware
  module PD
    describe AdequacyResult, type: :model do
      it_behaves_like "an Accountable model"
      it :aggregate_failures do
        is_expected.to belong_to(:patient).touch(true)
        is_expected.to validate_presence_of(:performed_on)
      end

      describe AdequacyResult::CalculatedAttributes do
        describe "#to_h" do
          it "returns am empty hash if no adequacy result passed" do
            visit = Clinics::ClinicVisit.new
            expect(described_class.new(adequacy: nil, clinic_visit: visit).calculate).to eq({})
          end

          it "returns am empty hash if no clinic visit passed" do
            adequacy = AdequacyResult.new
            expect(described_class.new(adequacy: adequacy, clinic_visit: nil).calculate).to eq({})
          end
        end

        # describe "#renal_urine_clearance" do

        # end
      end
    end
  end
end
