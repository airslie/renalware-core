# frozen_string_literal: true

require "rails_helper"

describe Renalware::Clinics::TotalBodyWater, type: :model do
  let(:patient) do
    Renalware::Clinics.cast_patient(create(:patient, sex: sex, born_on: 50.years.ago))
  end
  let(:sex) { "F" }

  def create_clinic_visit(weight: 100.99, height: 1.23)
    create(:clinic_visit, patient: patient, weight: weight, height: height)
  end

  describe "#calculate" do
    context "when no recent weight measurement found" do
      it "returns nil" do
        visit = create_clinic_visit(weight: nil)

        expect(described_class.new(visit: visit).calculate).to be_nil
      end
    end

    context "when patient has no sex" do
      it "returns nil" do
        # NB having to skip validations here in order to null out sex.
        # The column definition allows nulls but the model does not.
        patient.update_column(:sex, nil)
        visit = create_clinic_visit

        expect(described_class.new(visit: visit).calculate).to be_nil
      end
    end

    context "when patient has a sex which is neither M or F" do
      let(:sex) { "NK" }

      it "returns 0" do
        visit = create_clinic_visit

        expect(patient.sex.to_s).to eq("NK")
        expect(described_class.new(visit: visit).calculate).to be_nil
      end
    end

    context "when height and weight are available in a recent clinic visit" do
      context "when male" do
        let(:sex) { "M" }

        it "returns the correct calculated TBW rounded to default 2 dp" do
          visit = create_clinic_visit

          result = described_class.new(visit: visit).calculate

          # 2.447 - 0.09156 X age + 0.1074 X height (cm) + 0.3362 X weight (kg)
          # See https://qxmd.com/calculate/calculator_344/total-body-water-watson-formula
          # for a calculator
          expect(patient.sex.to_s).to eq("M")
          expect(result).to eq(45.03)
        end
      end

      context "when female" do
        let(:sex) { "F" }

        it "returns the correct calculated TBW rounded to default 2 dp" do
          result = described_class.new(visit: create_clinic_visit).calculate

          # -2.097 + 0.1069 X height (cm) + 0.2466 X weight (kg)
          # See https://qxmd.com/calculate/calculator_344/total-body-water-watson-formula
          # for a calculator
          expect(patient.sex.to_s).to eq("F")
          expect(result).to eq(35.96)
        end

        it "can get more decimal places if requested" do
          create_clinic_visit

          result = described_class.new(visit: create_clinic_visit).calculate(dp: 4)

          expect(result).to eq(35.9558)
        end
      end
    end
  end

  describe "self.calculate convenience class method" do
    let(:sex) { "M" }

    it do
      result = described_class.calculate(visit: create_clinic_visit, dp: 3)

      expect(result).to eq(45.032)
    end
  end
end
