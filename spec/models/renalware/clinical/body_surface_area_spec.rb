# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Clinical
    describe BodySurfaceArea, type: :model do
      describe "#calculate" do
        let(:patient) { Renalware::Clinics.cast_patient(create(:patient)) }

        context "when no recent weight measurement found" do
          it "returns 0" do
            create(:clinic_visit, patient: patient, height: 1.23, weight: nil)

            expect(described_class.new(patient: patient).calculate).to eq(0)
          end
        end

        context "when height and weight are available in recent clinic visits" do
          it "returns the correct calculated BSA rounded to default 3 dp" do
            create(:clinic_visit, patient: patient, height: 1.23, weight: nil)
            create(:clinic_visit, patient: patient, height: 1.23, weight: 100.99, date: 1.day.ago)

            # BSA = 0.007184*Weight^0.425*(Height)^0.725 eg 0.059342499887066046
            expect(described_class.new(patient: patient).calculate).to eq(0.059)
          end

          it "returns the correct calculated BSA rounded to the requested dp" do
            create(:clinic_visit, patient: patient, height: 1.23, weight: nil)
            create(:clinic_visit, patient: patient, height: 1.23, weight: 100.99, date: 1.day.ago)
            result = described_class.new(patient: patient, dp: 2).calculate

            expect(result).to eq(0.06)
          end
        end
      end
    end
  end
end
