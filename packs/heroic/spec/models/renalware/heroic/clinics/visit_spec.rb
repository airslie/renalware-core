# frozen_string_literal: true

require "rails_helper"

module Renalware::Heroic
  RSpec.describe Clinics::Visit do
    describe "#document" do
      subject(:document) { described_class.new.document }

      it { is_expected.to respond_to(:visit_number) }
      it { is_expected.to respond_to(:cuff_size) }
      it { is_expected.to respond_to(:physical_activity) }
      it { is_expected.to respond_to(:smoking) }
      it { is_expected.to respond_to(:alcohol) }
      it { is_expected.to respond_to(:urinalysis) }

      describe "#smoking" do
        subject { document.smoking }

        it { is_expected.to respond_to(:history) }
        it { is_expected.to respond_to(:number) }
        it { is_expected.to respond_to(:ecigarettes) }

        it { is_expected.to validate_numericality_of(:number) }
      end

      describe "#alcohol" do
        subject { document.alcohol }

        it { is_expected.to respond_to(:history) }
        it { is_expected.to respond_to(:units) }

        it { is_expected.to validate_numericality_of(:units) }
      end

      describe "#urinalysis" do
        subject { document.urinalysis }

        it { is_expected.to respond_to(:glucose) }
        it { is_expected.to respond_to(:nitrate) }
        it { is_expected.to respond_to(:leucocytes) }
        it { is_expected.to respond_to(:specific_gravity) }
      end

      describe "#health_status aka eq5d5l" do
        subject { document.health_status }

        it { is_expected.to respond_to(:mobility) }
        it { is_expected.to respond_to(:self_care) }
        it { is_expected.to respond_to(:usual_activities) }
        it { is_expected.to respond_to(:pain) }
        it { is_expected.to respond_to(:anxiety) }
        it { is_expected.to respond_to(:health_today_out_of_100) }
        it { is_expected.to validate_numericality_of(:health_today_out_of_100) }
      end

      describe ".save" do
        context "when there are 3 Heroic blood pressure readings" do
          it "stores the lowest heroic bp result to the top-level visit bp fields so that it will "\
             "be displayed in the clinic visit list" do
            visit = build(
              :heroic_clinic_visit,
              systolic_bp: nil,
              diastolic_bp: nil
            )
            visit.document.blood_pressure1 = ::Renalware::BloodPressure.new(
              systolic: 100,
              diastolic: 80
            )
            # blood_pressure2 is the lowest
            visit.document.blood_pressure2 = ::Renalware::BloodPressure.new(
              systolic: 99,
              diastolic: 78
            )
            visit.document.blood_pressure3 = ::Renalware::BloodPressure.new(
              systolic: 110,
              diastolic: 90
            )

            visit.save!

            visit.reload
            expect(visit.systolic_bp).to eq(99) # visit.document.blood_pressure2.systolic
            expect(visit.diastolic_bp).to eq(78) # visit.document.blood_pressure2.diastolic
          end
        end

        context "when there are no Heroic blood pressure readings" do
          it "puts nil into the top-level visit bp attributes" do
            visit = build(
              :heroic_clinic_visit,
              systolic_bp: nil,
              diastolic_bp: nil
            )
            visit.document.blood_pressure1 = ::Renalware::BloodPressure.new
            visit.document.blood_pressure2 = ::Renalware::BloodPressure.new
            visit.document.blood_pressure3 = ::Renalware::BloodPressure.new

            visit.save!

            visit.reload
            expect(visit.systolic_bp).to be_nil
            expect(visit.diastolic_bp).to be_nil
          end
        end

        context "when there is one Heroic blood pressure reading" do
          it "puts it into the top-level visit bp attributes" do
            visit = build(
              :heroic_clinic_visit,
              systolic_bp: nil,
              diastolic_bp: nil
            )
            visit.document.blood_pressure1 = ::Renalware::BloodPressure.new(
              systolic: 100,
              diastolic: 80
            )
            visit.document.blood_pressure2 = ::Renalware::BloodPressure.new
            visit.document.blood_pressure3 = ::Renalware::BloodPressure.new

            visit.save!

            visit.reload
            expect(visit.systolic_bp).to eq(100)
            expect(visit.diastolic_bp).to eq(80)
          end
        end
      end
    end
  end
end
