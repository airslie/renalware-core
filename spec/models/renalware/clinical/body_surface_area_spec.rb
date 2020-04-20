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

        context "when height and weight are available in a recent clinic visit" do
          it "returns the correct calculated BSA rounded to default 2 dp" do
            # The top most recent visit will be ignored as we only look for the most recent visit
            # where weight was recorded - so in this case the visit 10 days ago
            create(:clinic_visit, patient: patient, height: 1.21, weight: nil, date: 1.day.ago)
            create(:clinic_visit, patient: patient, height: 1.23, weight: 100.99, date: 10.days.ago)

            result = described_class.new(patient: patient).calculate

            # BSA = 0.007184 * Weight (kg) ^0.425 * Height (cm) ^0.725
            # To calculate see e.g.
            # https://www.msdmanuals.com/en-gb/medical-calculators/BodySurfaceArea.htm
            expect(result).to eq(1.67)
          end

          it "returns the correct calculated BSA rounded to the requested dp" do
            create(:clinic_visit, patient: patient, height: 1.23, weight: 100.99, date: 1.day.ago)

            result = described_class.new(patient: patient).calculate(dp: 3)

            expect(result).to eq(1.672)
          end
        end
      end
    end
  end
end
