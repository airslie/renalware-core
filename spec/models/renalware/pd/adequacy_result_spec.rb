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
            expect(described_class.new(adequacy: nil, clinic_visit: visit).to_h).to eq({})
          end

          it "returns am empty hash if no clinic visit passed" do
            adequacy = AdequacyResult.new
            expect(described_class.new(adequacy: adequacy, clinic_visit: nil).to_h).to eq({})
          end
        end

        describe "#renal_urine_clearance" do
          subject do
            described_class.new(adequacy: adequacy, clinic_visit: nil).renal_urine_clearance
          end

          let(:adequacy) { AdequacyResult.new(urine_urea: 10, serum_urea: 20, urine_24_vol: 3000) }

          context "when all values are present" do
            it { is_expected.to eq(10.5) }
          end

          context "when urine_24_missing is true" do
            before { adequacy.urine_24_missing = true }

            it { is_expected.to be_nil }
          end

          context "when urine_urea, serum_urea, urine_24_vol are zero or nil" do
            attrs = %i(urine_urea serum_urea urine_24_vol)
            invalid_values = [nil, 0]

            attrs.each do |attr|
              invalid_values.each do |val|
                before { adequacy.public_send(:"#{attr}=", val) }

                it { is_expected.to be_nil }
              end
            end
          end
        end

        describe "#renal_creatinine_clearance" do
          subject do
            described_class.new(adequacy: adequacy, clinic_visit: nil).renal_creatinine_clearance
          end

          let(:adequacy) do
            AdequacyResult.new(urine_creatinine: 10, serum_creatinine: 20, urine_24_vol: 3000)
          end

          context "when all values are present" do
            it { is_expected.to eq(10500.0) }
          end

          context "when urine_24_missing is true" do
            before { adequacy.urine_24_missing = true }

            it { is_expected.to be_nil }
          end

          context "when urine_creatinine, serum_creatinine, urine_24_vol are zero or nil" do
            attrs = %i(urine_creatinine serum_creatinine urine_24_vol)
            invalid_values = [nil, 0]

            attrs.each do |attr|
              invalid_values.each do |val|
                before { adequacy.public_send(:"#{attr}=", val) }

                it { is_expected.to be_nil }
              end
            end
          end
        end

        describe "#residual_renal_function" do
          subject do
            described_class.new(adequacy: adequacy, clinic_visit: visit).residual_renal_function
          end

          let(:adequacy) do
            AdequacyResult.new(
              urine_urea: 10,
              serum_urea: 20,
              urine_creatinine: 30,
              serum_creatinine: 40,
              urine_24_vol: 3000
            )
          end

          let(:visit) do
            Clinics::ClinicVisit.new(body_surface_area: 100)
          end

          context "when all values are present" do
            it { is_expected.to eq(135) }
          end

          context "when body_surface_area is nil" do
            before { visit.body_surface_area = nil }

            it { is_expected.to be_nil }
          end

          context "when body_surface_area is 0" do
            before { visit.body_surface_area = 0 }

            it { is_expected.to be_nil }
          end

          context "when renal_urine_clearance is nil" do
            before { adequacy.urine_24_missing = true }

            it { is_expected.to be_nil }
          end
        end

        describe "#pertitoneal_creatinine_clearance" do
          subject do
            described_class.new(adequacy: adequacy, clinic_visit: visit)
              .pertitoneal_creatinine_clearance
          end

          let(:adequacy) do
            AdequacyResult.new(
              urine_urea: 10,
              serum_urea: 20,
              urine_creatinine: 30,
              serum_creatinine: 40,
              urine_24_vol: 3000,
              dialysate_creatinine: 200,
              dial_24_vol_out: 2000
            )
          end

          let(:visit) do
            Clinics::ClinicVisit.new(body_surface_area: 10)
          end

          context "when all values are present" do
            it { is_expected.to eq(12) }
          end

          context "when body_surface_area is nil" do
            before { visit.body_surface_area = nil }

            it { is_expected.to be_nil }
          end

          context "when body_surface_area is 0" do
            before { visit.body_surface_area = 0 }

            it { is_expected.to be_nil }
          end

          context "when dialysate_creatinine, serum_creatinine, dial_24_vol_out are zero or nil" do
            attrs = %i(dialysate_creatinine serum_creatinine dial_24_vol_out)
            invalid_values = [nil, 0]

            attrs.each do |attr|
              invalid_values.each do |val|
                before { adequacy.public_send(:"#{attr}=", val) }

                it { is_expected.to be_nil }
              end
            end
          end
        end
      end
    end
  end
end
