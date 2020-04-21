# frozen_string_literal: true

require "rails_helper"

describe Renalware::Clinics::BodySurfaceArea, type: :model do
  let(:patient) { Renalware::Clinics.cast_patient(create(:patient)) }

  def create_clinic_visit(height: 1.23, weight: 100.99)
    create(:clinic_visit, patient: patient, height: height, weight: weight)
  end

  describe "#calculate" do
    context "when the visit has no weight" do
      it "returns null" do
        visit = create_clinic_visit(weight: nil)

        result = described_class.new(visit: visit).calculate

        expect(result).to be_nil
      end
    end

    context "when a visit has height and weight" do
      it "returns the correct calculated BSA rounded to default 2 dp" do
        visit = create_clinic_visit(height: 1.23, weight: 100.99)

        result = described_class.new(visit: visit).calculate

        # BSA = 0.007184 * Weight (kg) ^0.425 * Height (cm) ^0.725
        # To calculate see e.g.
        # https://www.msdmanuals.com/en-gb/medical-calculators/BodySurfaceArea.htm
        expect(result).to eq(1.67)
      end

      it "returns the correct calculated BSA rounded to the requested dp" do
        visit = create_clinic_visit(height: 1.23, weight: 100.99)

        result = described_class.new(visit: visit).calculate(dp: 3)

        expect(result).to eq(1.672)
      end
    end
  end

  describe "self.calculate convenience class method" do
    it do
      visit = create_clinic_visit(height: 1.23, weight: 100.99)

      result = described_class.calculate(visit: visit, dp: 3)

      expect(result).to eq(1.672)
    end
  end
end
